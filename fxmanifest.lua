fx_version 'adamant'

game 'gta5'
author 'kaiz2604'
version '1.0.0'
ui_page('html/index.html') 
files({
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/imgs/*.png',
  })
shared_script '@es_extended/imports.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua',
}

client_scripts {
	'config.lua',
	'client.lua'
}

dependencies {
	'es_extended',
}
