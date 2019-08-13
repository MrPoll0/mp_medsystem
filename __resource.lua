description "Medic System by MrPoll0"

client_scripts {
	'client/main.lua'
}
dependencies {
	'mp_medsystem',
	'mp_medsystemComp'
}
server_scripts {
	'server/main.lua',
	'@mysql-async/lib/MySQL.lua'
}

files {
	"html/css/style.css",
	"html/css/cuerpo.css",
	"html/css/pulso.css",
	"html/index.html",
	"html/app.js",
	"html/img/venda_compresiva.png",
	"html/img/Venda.png",
	"html/img/Tramadol.png",
	"html/img/Morfina.png",
	"html/img/bolsa_de_sangre.png",
	"html/img/Desfibrilador.png",
	"html/img/fondo.jpg",
	"html/img/pulso.png",
	'html/fonts/gta-ui.ttf',
}


ui_page {
	'html/index.html'
}
