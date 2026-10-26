extends Node

var language: String = "pt"

var texts: Dictionary = {
	"pt": {
		"time": "TEMPO",
		"paused": "JOGO PAUSADO",
		"continue": "CONTINUAR",
		"menu": "MENU INICIAL",
		"quit": "SAIR DO JOGO",
		"game_over": "GAME OVER",
		"destroyed": "A nave foi destruída.",
		"survived": "Você sobreviveu por %s",
		"restart": "REINICIAR"
	},
	"en": {
		"time": "TIME",
		"paused": "GAME PAUSED",
		"continue": "CONTINUE",
		"menu": "MAIN MENU",
		"quit": "QUIT GAME",
		"game_over": "GAME OVER",
		"destroyed": "The ship was destroyed.",
		"survived": "You survived for %s",
		"restart": "RESTART"
	},
	"fr": {
		"time": "TEMPS",
		"paused": "JEU EN PAUSE",
		"continue": "CONTINUER",
		"menu": "MENU PRINCIPAL",
		"quit": "QUITTER",
		"game_over": "FIN DE PARTIE",
		"destroyed": "Le vaisseau a été détruit.",
		"survived": "Vous avez survécu %s",
		"restart": "RECOMMENCER"
	},
	"it": {
		"time": "TEMPO",
		"paused": "GIOCO IN PAUSA",
		"continue": "CONTINUA",
		"menu": "MENU PRINCIPALE",
		"quit": "ESCI DAL GIOCO",
		"game_over": "GAME OVER",
		"destroyed": "La nave è stata distrutta.",
		"survived": "Hai resistito per %s",
		"restart": "RICOMINCIA"
	},
	"es": {
		"time": "TIEMPO",
		"paused": "JUEGO EN PAUSA",
		"continue": "CONTINUAR",
		"menu": "MENÚ PRINCIPAL",
		"quit": "SALIR DEL JUEGO",
		"game_over": "FIN DEL JUEGO",
		"destroyed": "La nave fue destruida.",
		"survived": "Sobreviviste durante %s",
		"restart": "REINICIAR"
	},
	"ru": {
		"time": "ВРЕМЯ",
		"paused": "ИГРА НА ПАУЗЕ",
		"continue": "ПРОДОЛЖИТЬ",
		"menu": "ГЛАВНОЕ МЕНЮ",
		"quit": "ВЫЙТИ ИЗ ИГРЫ",
		"game_over": "ИГРА ОКОНЧЕНА",
		"destroyed": "Корабль был уничтожен.",
		"survived": "Вы продержались %s",
		"restart": "ЗАНОВО"
	},
	"zh": {
		"time": "时间",
		"paused": "游戏暂停",
		"continue": "继续",
		"menu": "主菜单",
		"quit": "退出游戏",
		"game_over": "游戏结束",
		"destroyed": "飞船被摧毁了。",
		"survived": "你坚持了 %s",
		"restart": "重新开始"
	}
}

func translate(key: String) -> String:
	var selected: Dictionary = texts.get(language, texts["pt"])
	return str(selected.get(key, key))
