# EMS/Police Garage System for QBCore

A comprehensive garage system for emergency services (Police and Ambulance) in QBCore FiveM servers.

## Features

- **NPC Interaction**: Target-based interaction with garage NPCs
- **Grade-based Access**: Different vehicles available based on job grade
- **Vehicle Spawning**: Spawn vehicles from a menu based on your grade
- **Vehicle Return**: Return vehicles using E key at designated return points
- **Job Validation**: Only accessible by players with the correct job
- **Automatic Cleanup**: Vehicles are automatically cleaned up on disconnect/resource stop

## Installation

1. Place the script in your `resources` folder
2. Add `ensure rf-jobgarage` to your `server.cfg`
3. Make sure you have `qb-core` and `qb-target` installed and running
4. Configure the coordinates and vehicle lists in `config.lua`

## Configuration

### NPC Locations
Edit the coordinates in `config.lua` to place NPCs where you want them:

```lua
Config.NPC = {
    model = 's_m_y_cop_01',
    coords = vector4(452.0, -1018.0, 28.5, 0.0), -- x, y, z, heading
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}
```

### Vehicle Spawn Points
Configure where vehicles spawn:

```lua
Config.SpawnPoints = {
    police = {
        coords = vector4(452.0, -1018.0, 28.5, 0.0),
        heading = 0.0
    }
}
```

### Vehicle Return Points
Set the coordinates where players can return vehicles:

```lua
Config.ReturnPoints = {
    police = {
        coords = vector3(452.0, -1018.0, 28.5),
        radius = 3.0
    }
}
```

### Vehicle Lists
Add or modify vehicles available for each grade:

```lua
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
        }
    }
}
```

## Usage

1. **Accessing the Garage**: Target the NPC and select "Access [Service] Garage"
2. **Spawning Vehicles**: Choose a vehicle from the menu based on your grade
3. **Returning Vehicles**: Drive to the return point and press E to return the vehicle

## Job Requirements

- **Police Garage**: Requires `police` job
- **Ambulance Garage**: Requires `ambulance` job

## Dependencies

- qb-core
- qb-target
- qb-menu (for the vehicle selection menu)

## Customization

### Adding New Vehicles
To add new vehicles, simply add them to the appropriate grade in `Config.Vehicles`:

```lua
{model = 'your_vehicle_model', label = 'Your Vehicle Name', price = 0}
```

### Changing NPC Models
Modify the `model` field in the NPC configuration:

```lua
Config.NPC = {
    model = 'your_npc_model', -- Change this
    coords = vector4(x, y, z, heading),
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}
```

### Adding New Services
To add a new service (like Fire Department), you'll need to:

1. Add a new NPC configuration
2. Add spawn and return points
3. Add vehicle lists for the new service
4. Update the client script to handle the new service type

## Troubleshooting

- **NPCs not spawning**: Check if the coordinates are valid and not inside objects
- **Vehicles not spawning**: Ensure the spawn coordinates are clear and accessible
- **Menu not opening**: Verify that qb-target and qb-menu are properly installed
- **Return not working**: Check that the return point coordinates and radius are correct

## Support

If you encounter any issues, check the console for errors and ensure all dependencies are properly installed and running.

---

## Copyright

Copyright (c) 2025 ireff25 (Discord: ireff25). All rights reserved.
