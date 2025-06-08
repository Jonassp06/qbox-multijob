fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Jonassp06'
description 'Simple Qbox multijob script using ox_lib'

shared_scripts {
    'config.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@ox_lib/init.lua',
    'server.lua'
}