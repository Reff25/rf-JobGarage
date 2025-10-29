-- Copyright (c) 2025 ireff25 (Discord: ireff25)
-- All rights reserved.

Config = {}

-- NPC Settings
Config.NPC = {
    model = 's_m_y_ranger_01', -- Police NPC model
    coords = vector4(454.8701, -1024.5592, 28.4769, 2.5940), -- x, y, z, heading
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}

-- Ambulance NPC Settings
Config.AmbulanceNPC = {
    model = 's_m_m_paramedic_01', -- Ambulance NPC model
    coords = vector4(307.0, -1433.0, 29.9, 0.0), -- x, y, z, heading
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}

-- Vehicle Spawn Points
Config.SpawnPoints = {
    police = {
        coords = vector4(449.4411, -1025.3962, 28.5855, 10.6655),
        heading = 2.5940
    },
    ambulance = {
        coords = vector4(307.0, -1433.0, 29.9, 0.0),
        heading = 0.0
    }
}

-- Vehicle Return Points
Config.ReturnPoints = {
    police = {
        coords = vector3(449.4411, -1025.3962, 28.5855),
        radius = 3.0
    },
    ambulance = {
        coords = vector3(307.0, -1433.0, 29.9),
        radius = 3.0
    }
}

-- Vehicle Lists by Grade
Config.Vehicles = {
    police = {
        [0] = { -- Grade 0 - Cadet
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0}
        },
        [1] = { -- Grade 1 - Officer
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0},
            {model = 'police3', label = 'Police Cruiser 3', price = 0}
        },
        [2] = { -- Grade 2 - Senior Officer
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0},
            {model = 'police3', label = 'Police Cruiser 3', price = 0},
            {model = 'polmav', label = 'Police Maverick', price = 0}
        },
        [3] = { -- Grade 3 - Sergeant
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0},
            {model = 'police3', label = 'Police Cruiser 3', price = 0},
            {model = 'polmav', label = 'Police Maverick', price = 0},
            {model = 'policeb', label = 'Police Bike', price = 0}
        },
        [4] = { -- Grade 4 - Lieutenant
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0},
            {model = 'police3', label = 'Police Cruiser 3', price = 0},
            {model = 'polmav', label = 'Police Maverick', price = 0},
            {model = 'policeb', label = 'Police Bike', price = 0},
            {model = 'sheriff2', label = 'Sheriff SUV', price = 0}
        },
        [5] = { -- Grade 5 - Captain
            {model = 'police', label = 'Police Cruiser', price = 0},
            {model = 'police2', label = 'Police Cruiser 2', price = 0},
            {model = 'police3', label = 'Police Cruiser 3', price = 0},
            {model = 'polmav', label = 'Police Maverick', price = 0},
            {model = 'policeb', label = 'Police Bike', price = 0},
            {model = 'sheriff2', label = 'Sheriff SUV', price = 0},
            {model = 'fbi', label = 'FBI Vehicle', price = 0}
        }
    },
    ambulance = {
        [0] = { -- Grade 0 - EMT
            {model = 'ambulance', label = 'Ambulance', price = 0}
        },
        [1] = { -- Grade 1 - Paramedic
            {model = 'ambulance', label = 'Ambulance', price = 0},
            {model = 'lguard', label = 'Lifeguard', price = 0}
        },
        [2] = { -- Grade 2 - Senior Paramedic
            {model = 'ambulance', label = 'Ambulance', price = 0},
            {model = 'lguard', label = 'Lifeguard', price = 0},
            {model = 'polmav', label = 'Medical Helicopter', price = 0}
        },
        [3] = { -- Grade 3 - Supervisor
            {model = 'ambulance', label = 'Ambulance', price = 0},
            {model = 'lguard', label = 'Lifeguard', price = 0},
            {model = 'polmav', label = 'Medical Helicopter', price = 0},
            {model = 'fbi2', label = 'Medical SUV', price = 0}
        },
        [4] = { -- Grade 4 - Manager
            {model = 'ambulance', label = 'Ambulance', price = 0},
            {model = 'lguard', label = 'Lifeguard', price = 0},
            {model = 'polmav', label = 'Medical Helicopter', price = 0},
            {model = 'fbi2', label = 'Medical SUV', price = 0},
            {model = 'sheriff2', label = 'Medical Command', price = 0}
        },
        [5] = { -- Grade 5 - Director
            {model = 'ambulance', label = 'Ambulance', price = 0},
            {model = 'lguard', label = 'Lifeguard', price = 0},
            {model = 'polmav', label = 'Medical Helicopter', price = 0},
            {model = 'fbi2', label = 'Medical SUV', price = 0},
            {model = 'sheriff2', label = 'Medical Command', price = 0},
            {model = 'fbi', label = 'Medical Director Vehicle', price = 0}
        }
    }
}

-- Job Names
Config.PoliceJob = 'police'
Config.AmbulanceJob = 'ambulance'
