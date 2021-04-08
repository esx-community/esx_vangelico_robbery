fx_version 'cerulean'
game 'gta5'

description 'ESX Vangelico Robbery'
version '2.0.0'
author 'Original Author: SerseDioRe. Edited by Vyast#0001.'

client_script 'client/client.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'server/server.lua'
}

shared_scripts {
	'config.lua'
}

