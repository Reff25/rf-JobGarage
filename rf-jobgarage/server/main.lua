-- Copyright (c) 2025 ireff25 (Discord: ireff25)
-- All rights reserved.

local QBCore = exports['qb-core']:GetCoreObject()
local spawnedVehicles = {}

-- Get player's spawned vehicle
QBCore.Functions.CreateCallback('rf-jobgarage:server:getPlayerVehicle', function(source, cb)
    local playerId = source
    cb(spawnedVehicles[playerId])
end)

-- Set player's spawned vehicle
QBCore.Functions.CreateCallback('rf-jobgarage:server:setPlayerVehicle', function(source, cb, vehicleData)
    local playerId = source
    spawnedVehicles[playerId] = vehicleData
    cb(true)
end)

-- Remove player's spawned vehicle
QBCore.Functions.CreateCallback('rf-jobgarage:server:removePlayerVehicle', function(source, cb)
    local playerId = source
    spawnedVehicles[playerId] = nil
    cb(true)
end)

-- Validate player access to garage
QBCore.Functions.CreateCallback('rf-jobgarage:server:validateAccess', function(source, cb, garageType)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end
    
    local job = Player.PlayerData.job.name
    local grade = Player.PlayerData.job.grade.level
    
    -- Check if player has the correct job
    if garageType == "police" and job ~= Config.PoliceJob then
        cb(false)
        return
    elseif garageType == "ambulance" and job ~= Config.AmbulanceJob then
        cb(false)
        return
    end
    
    -- Check if player has access to vehicles for their grade
    local vehicles = Config.Vehicles[garageType]
    if not vehicles or not vehicles[grade] or #vehicles[grade] == 0 then
        cb(false)
        return
    end
    
    cb(true)
end)

-- Clean up when player disconnects
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    if spawnedVehicles[playerId] then
        spawnedVehicles[playerId] = nil
    end
end)

-- Clean up on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Clean up all spawned vehicles
        for playerId, vehicleData in pairs(spawnedVehicles) do
            spawnedVehicles[playerId] = nil
        end
    end
end)
