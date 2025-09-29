fx_version 'cerulean'
game 'gta5'

author 'StnDev'
description 'Trucker Job - ESX Free Release'
version '1.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'es_extended'
}
