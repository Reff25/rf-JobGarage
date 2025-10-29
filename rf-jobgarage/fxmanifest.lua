-- Copyright (c) 2025 ireff25 (Discord: ireff25)
-- All rights reserved.

fx_version 'cerulean'
game 'gta5'

author 'Reff'
description 'Emergency Services Garage System for QBCore'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qb-core',
    'qb-target',
    'ox_lib'
}
