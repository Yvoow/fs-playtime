fx_version "adamant"
game "gta5"
use_fxv2_oal "yes"
lua54 "yes"

shared_scripts { 
    '@es_extended/imports.lua',
    'config.lua'
}

server_scripts { 
    '@oxmysql/lib/MySQL.lua', 
    'server/*.lua',
    'config.lua'
}