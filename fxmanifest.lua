fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "TJ Burgershot"
description "TJ Advanced burgershot script"
author "TJ Scripts (https://discord.gg/tbSF4N7eCb)"
version "1.3.0"

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'locales/*.json'
}

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}