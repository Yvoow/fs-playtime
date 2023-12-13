fx_version 'adamant'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'
server_only 'yes'

server_scripts { 
    '@es_extended/imports.lua',
    '@oxmysql/lib/MySQL.lua', 
    'server/*.lua',
    'config.lua'
}