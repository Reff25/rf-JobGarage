-- Copyright (c) 2025 ireff25 (Discord: ireff25)
-- All rights reserved.

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local spawnedVehicles = {}
local currentJob = nil
local currentGrade = nil

-- Initialize
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    currentJob = PlayerData.job.name
    currentGrade = PlayerData.job.grade.level
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    currentJob = PlayerData.job.name
    currentGrade = PlayerData.job.grade.level
end)

-- Spawn NPCs when resource starts
CreateThread(function()
    Wait(1000) -- Wait for everything to load
    SpawnNPCs()
    
    -- Get player data if not loaded yet
    if not PlayerData or not PlayerData.job then
        PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job then
            currentJob = PlayerData.job.name
            currentGrade = PlayerData.job.grade.level
        end
    end
end)

-- Spawn NPCs
function SpawnNPCs()
    -- Request model for Police NPC
    local policeModel = GetHashKey(Config.NPC.model)
    RequestModel(policeModel)
    while not HasModelLoaded(policeModel) do
        Wait(1)
    end
    
    -- Police NPC
    local policeNPC = CreatePed(4, policeModel, Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z - 1.0, Config.NPC.coords.w, false, true)
    if DoesEntityExist(policeNPC) then
        FreezeEntityPosition(policeNPC, true)
        SetEntityInvincible(policeNPC, true)
        SetBlockingOfNonTemporaryEvents(policeNPC, true)
        TaskStartScenarioInPlace(policeNPC, Config.NPC.scenario, 0, true)
        SetModelAsNoLongerNeeded(policeModel)
    end
    
    -- Request model for Ambulance NPC
    local ambulanceModel = GetHashKey(Config.AmbulanceNPC.model)
    RequestModel(ambulanceModel)
    while not HasModelLoaded(ambulanceModel) do
        Wait(1)
    end
    
    -- Ambulance NPC
    local ambulanceNPC = CreatePed(4, ambulanceModel, Config.AmbulanceNPC.coords.x, Config.AmbulanceNPC.coords.y, Config.AmbulanceNPC.coords.z - 1.0, Config.AmbulanceNPC.coords.w, false, true)
    if DoesEntityExist(ambulanceNPC) then
        FreezeEntityPosition(ambulanceNPC, true)
        SetEntityInvincible(ambulanceNPC, true)
        SetBlockingOfNonTemporaryEvents(ambulanceNPC, true)
        TaskStartScenarioInPlace(ambulanceNPC, Config.AmbulanceNPC.scenario, 0, true)
        SetModelAsNoLongerNeeded(ambulanceModel)
    end
    
    -- Add targeting
    exports['qb-target']:AddTargetEntity(policeNPC, {
        options = {
            {
                type = "client",
                event = "rf-jobgarage:client:openGarageMenu",
                icon = "fas fa-car",
                label = "Access Police Garage",
                job = Config.PoliceJob,
                garageType = "police"
            }
        },
        distance = 2.0
    })
    
    exports['qb-target']:AddTargetEntity(ambulanceNPC, {
        options = {
            {
                type = "client",
                event = "rf-jobgarage:client:openGarageMenu",
                icon = "fas fa-car",
                label = "Access Ambulance Garage",
                job = Config.AmbulanceJob,
                garageType = "ambulance"
            }
        },
        distance = 2.0
    })
end

-- Open Garage Menu
RegisterNetEvent('rf-jobgarage:client:openGarageMenu', function(data)
    if not data.garageType then return end
    
    local garageType = data.garageType
    local playerId = GetPlayerServerId(PlayerId())
    
    -- Always check if player has a vehicle in records, regardless of distance
    if spawnedVehicles[playerId] then
        -- Show vehicle management menu
        ShowVehicleManagementMenu(garageType)
    else
        -- Show vehicle spawn menu
        ShowVehicleSpawnMenu(garageType)
    end
end)

-- Show Vehicle Management Menu
function ShowVehicleManagementMenu(garageType)
    local playerId = GetPlayerServerId(PlayerId())
    local vehicleData = spawnedVehicles[playerId]
    local vehicle = vehicleData.vehicle
    
    local options = {
        {
            title = '🚗 Set Waypoint to Vehicle',
            description = 'Set GPS waypoint to your spawned vehicle',
            icon = 'fas fa-map-marker-alt',
            onSelect = function()
                if DoesEntityExist(vehicle) then
                    local coords = GetEntityCoords(vehicle)
                    SetNewWaypoint(coords.x, coords.y)
                    lib.notify({
                        title = 'Waypoint Set',
                        description = 'GPS waypoint set to your vehicle',
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = 'Vehicle Not Found',
                        description = 'Vehicle may have been despawned',
                        type = 'error'
                    })
                end
            end
        },
        {
            title = '🔄 Try to Return Vehicle',
            description = 'Attempt to return vehicle (if despawned, use delete instead)',
            icon = 'fas fa-undo',
            onSelect = function()
                if DoesEntityExist(vehicle) then
                    local playerPed = PlayerPedId()
                    if GetVehiclePedIsIn(playerPed, false) == vehicle then
                        ReturnVehicle()
                    else
                        lib.notify({
                            title = 'Not in Vehicle',
                            description = 'You must be in the vehicle to return it',
                            type = 'error'
                        })
                    end
                else
                    lib.notify({
                        title = 'Vehicle Despawned',
                        description = 'Vehicle has been despawned. Use delete option instead.',
                        type = 'error'
                    })
                end
            end
        },
        {
            title = '🗑️ Delete Vehicle',
            description = 'Remove vehicle from records and despawn it',
            icon = 'fas fa-trash',
            onSelect = function()
                DeleteVehicle()
            end
        }
    }
    
    lib.registerContext({
        id = 'vehicle_management_menu',
        title = '🚔 Vehicle Management',
        options = options
    })
    
    lib.showContext('vehicle_management_menu')
end

-- Show Vehicle Spawn Menu
function ShowVehicleSpawnMenu(garageType)
    local vehicles = Config.Vehicles[garageType]
    
    if not vehicles then return end
    
    -- Check if player has access to vehicles for their grade
    local availableVehicles = vehicles[currentGrade] or {}
    
    if #availableVehicles == 0 then
        lib.notify({
            title = 'No Access',
            description = 'You don\'t have access to any vehicles for your grade!',
            type = 'error'
        })
        return
    end
    
    local options = {}
    
    for i, vehicle in ipairs(availableVehicles) do
        table.insert(options, {
            title = '🚗 ' .. vehicle.label,
            description = 'Spawn ' .. vehicle.label,
            icon = 'fas fa-car',
            onSelect = function()
                SpawnVehicle(vehicle.model, garageType)
            end
        })
    end
    
    lib.registerContext({
        id = 'vehicle_spawn_menu',
        title = '🚔 Emergency Services Garage',
        options = options
    })
    
    lib.showContext('vehicle_spawn_menu')
end

-- Delete Vehicle
function DeleteVehicle()
    local playerId = GetPlayerServerId(PlayerId())
    local vehicleData = spawnedVehicles[playerId]
    
    if not vehicleData then
        lib.notify({
            title = 'No Vehicle',
            description = 'No vehicle to delete!',
            type = 'error'
        })
        return
    end
    
    local vehicle = vehicleData.vehicle
    
    -- Force delete the vehicle if it exists
    if DoesEntityExist(vehicle) then
        -- Remove all players from vehicle first
        local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
        for i = -1, maxSeats - 1 do
            local ped = GetPedInVehicleSeat(vehicle, i)
            if ped ~= 0 then
                TaskLeaveVehicle(ped, vehicle, 0)
            end
        end
        
        -- Wait a moment then delete
        Wait(100)
        QBCore.Functions.DeleteVehicle(vehicle)
        
        -- Double check and force delete if still exists
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end
    
    -- Clear from records
    spawnedVehicles[playerId] = nil
    
    lib.notify({
        title = 'Vehicle Deleted',
        description = 'Vehicle has been removed and despawned',
        type = 'success'
    })
end

-- Spawn Vehicle
function SpawnVehicle(model, garageType)
    -- Check if player already has a vehicle spawned
    local playerId = GetPlayerServerId(PlayerId())
    if spawnedVehicles[playerId] then
        lib.notify({
            title = 'Vehicle Already Spawned',
            description = 'You already have a vehicle spawned! Manage it first.',
            type = 'error'
        })
        return
    end
    
    -- Get spawn point
    local spawnPoint = Config.SpawnPoints[garageType]
    if not spawnPoint then return end
    
    -- Request vehicle model
    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "EMS" .. math.random(1000, 9999))
        SetEntityHeading(veh, spawnPoint.heading)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
        
        -- Store vehicle info
        spawnedVehicles[playerId] = {
            vehicle = veh,
            plate = QBCore.Functions.GetPlate(veh),
            garageType = garageType
        }
        
        lib.notify({
            title = 'Vehicle Spawned',
            description = 'Vehicle spawned successfully!',
            type = 'success'
        })
        
        -- Start return point monitoring
        StartReturnPointMonitoring(garageType)
    end, spawnPoint.coords, true)
end

-- Start monitoring return point
function StartReturnPointMonitoring(garageType)
    local returnPoint = Config.ReturnPoints[garageType]
    if not returnPoint then return end
    
    CreateThread(function()
        while spawnedVehicles[GetPlayerServerId(PlayerId())] do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - returnPoint.coords)
            
            if distance <= returnPoint.radius then
                lib.showTextUI('[E] Return Vehicle', {
                    position = 'top-center',
                    icon = 'fas fa-car'
                })
                
                if IsControlJustPressed(0, 38) then -- E key
                    ReturnVehicle()
                    lib.hideTextUI()
                    break
                end
            else
                lib.hideTextUI()
            end
            
            Wait(0)
        end
    end)
end

-- Return Vehicle
function ReturnVehicle()
    local playerId = GetPlayerServerId(PlayerId())
    local vehicleData = spawnedVehicles[playerId]
    
    if not vehicleData then
        lib.notify({
            title = 'No Vehicle',
            description = 'No vehicle to return!',
            type = 'error'
        })
        return
    end
    
    local vehicle = vehicleData.vehicle
    
    if not DoesEntityExist(vehicle) then
        lib.notify({
            title = 'Vehicle Despawned',
            description = 'Vehicle has been despawned. Use the NPC to delete it from records.',
            type = 'error'
        })
        spawnedVehicles[playerId] = nil
        return
    end
    
    -- Check if player is in the vehicle
    if GetVehiclePedIsIn(PlayerPedId(), false) ~= vehicle then
        lib.notify({
            title = 'Not in Vehicle',
            description = 'You must be in the vehicle to return it!',
            type = 'error'
        })
        return
    end
    
    -- Delete vehicle
    QBCore.Functions.DeleteVehicle(vehicle)
    spawnedVehicles[playerId] = nil
    
    lib.notify({
        title = 'Vehicle Returned',
        description = 'Vehicle returned successfully!',
        type = 'success'
    })
end

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Clean up spawned vehicles
        for playerId, vehicleData in pairs(spawnedVehicles) do
            if DoesEntityExist(vehicleData.vehicle) then
                DeleteEntity(vehicleData.vehicle)
            end
        end
    end
end)