extends Control

const GAME_SCENE := "res://Main.tscn"

@onready var settings_panel: Panel = $SettingsPanel
@onready var status_label: Label = $StatusLabel
@onready var locale_manager: Node = get_node("/root/Locale")

var current_language: String = "pt"
var translations: Dictionary = {
	"pt": {
		"title": "NEON RUSH",
		"subtitle": "SOBREVIVA AO INFINITO",
		"quit": "SAIR DO JOGO",
		"new_game": "NOVO JOGO",
		"continue": "CONTINUAR",
		"settings": "CONFIGURAÇÕES",
		"settings_title": "CONFIGURAÇÕES",
		"volume": "VOLUME PRINCIPAL",
		"language": "IDIOMA",
		"close": "FECHAR",
		"no_save": "Nenhum jogo salvo encontrado."
	},
	"en": {
		"title": "NEON RUSH",
		"subtitle": "SURVIVE THE INFINITE",
		"quit": "QUIT GAME",
		"new_game": "NEW GAME",
		"continue": "CONTINUE",
		"settings": "SETTINGS",
		"settings_title": "SETTINGS",
		"volume": "MASTER VOLUME",
		"language": "LANGUAGE",
		"close": "CLOSE",
		"no_save": "No saved game found."
	},
	"fr": {
		"title": "NEON RUSH",
		"subtitle": "SURVIVEZ À L'INFINI",
		"quit": "QUITTER LE JEU",
		"new_game": "NOUVELLE PARTIE",
		"continue": "CONTINUER",
		"settings": "PARAMÈTRES",
		"settings_title": "PARAMÈTRES",
		"volume": "VOLUME PRINCIPAL",
		"language": "LANGUE",
		"close": "FERMER",
		"no_save": "Aucune partie sauvegardée."
	},
	"it": {
		"title": "NEON RUSH",
		"subtitle": "SOPRAVVIVI ALL'INFINITO",
		"quit": "ESCI DAL GIOCO",
		"new_game": "NUOVA PARTITA",
		"continue": "CONTINUA",
		"settings": "IMPOSTAZIONI",
		"settings_title": "IMPOSTAZIONI",
		"volume": "VOLUME PRINCIPALE",
		"language": "LINGUA",
		"close": "CHIUDI",
		"no_save": "Nessun salvataggio trovato."
	},
	"es": {
		"title": "NEON RUSH",
		"subtitle": "SOBREVIVE AL INFINITO",
		"quit": "SALIR DEL JUEGO",
		"new_game": "NUEVA PARTIDA",
		"continue": "CONTINUAR",
		"settings": "AJUSTES",
		"settings_title": "AJUSTES",
		"volume": "VOLUMEN PRINCIPAL",
		"language": "IDIOMA",
		"close": "CERRAR",
		"no_save": "No se encontró ninguna partida guardada."
	},
	"ru": {
		"title": "NEON RUSH",
		"subtitle": "ВЫЖИВАЙТЕ БЕСКОНЕЧНО",
		"quit": "ВЫЙТИ ИЗ ИГРЫ",
		"new_game": "НОВАЯ ИГРА",
		"continue": "ПРОДОЛЖИТЬ",
		"settings": "НАСТРОЙКИ",
		"settings_title": "НАСТРОЙКИ",
		"volume": "ОБЩАЯ ГРОМКОСТЬ",
		"language": "ЯЗЫК",
		"close": "ЗАКРЫТЬ",
		"no_save": "Сохранённая игра не найдена."
	},
	"zh": {
		"title": "霓虹冲刺",
		"subtitle": "在无尽空间中生存",
		"quit": "退出游戏",
		"new_game": "新游戏",
		"continue": "继续",
		"settings": "设置",
		"settings_title": "设置",
		"volume": "主音量",
		"language": "语言",
		"close": "关闭",
		"no_save": "没有找到已保存的游戏。"
	}
}

func _ready() -> void:
	current_language = locale_manager.language
	settings_panel.visible = false
	$SettingsPanel/LanguageOption.clear()
	$SettingsPanel/LanguageOption.add_item("Português")
	$SettingsPanel/LanguageOption.add_item("English")
	$SettingsPanel/LanguageOption.add_item("Français")
	$SettingsPanel/LanguageOption.add_item("Italiano")
	$SettingsPanel/LanguageOption.add_item("Español")
	$SettingsPanel/LanguageOption.add_item("Русский")
	$SettingsPanel/LanguageOption.add_item("普通话")
	$SettingsPanel/LanguageOption.select(0)
	_apply_language()
	$Menu/QuitButton.grab_focus()
	$Music.finished.connect(_on_music_finished)

func _on_music_finished() -> void:
	$Music.play()

func _on_new_game_button_pressed() -> void:
	_start_game()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_continue_button_pressed() -> void:
	if FileAccess.file_exists("user://savegame.save"):
		_start_game()
	else:
		status_label.text = str(translations[current_language]["no_save"])

func _on_settings_button_pressed() -> void:
	settings_panel.visible = not settings_panel.visible
	$Menu.visible = not settings_panel.visible
	$Menu.mouse_filter = Control.MOUSE_FILTER_IGNORE if settings_panel.visible else Control.MOUSE_FILTER_STOP
	if settings_panel.visible:
		$SettingsPanel/CloseButton.grab_focus()
	else:
		$Menu/SettingsButton.grab_focus()

func _on_close_button_pressed() -> void:
	settings_panel.visible = false
	$Menu.visible = true
	$Menu.mouse_filter = Control.MOUSE_FILTER_STOP
	$Menu/SettingsButton.grab_focus()

func _on_master_volume_value_changed(value: float) -> void:
	var normalized_volume: float = maxf(value * 0.5, 0.001)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(normalized_volume)
	)

func _on_language_option_item_selected(index: int) -> void:
	var languages: Array[String] = ["pt", "en", "fr", "it", "es", "ru", "zh"]
	current_language = languages[index]
	locale_manager.language = current_language
	_apply_language()

func _apply_language() -> void:
	var language: Dictionary = translations[current_language]
	$Title.text = str(language["title"])
	$Subtitle.text = str(language["subtitle"])
	$Menu/NewGameButton.text = str(language["new_game"])
	$Menu/ContinueButton.text = str(language["continue"])
	$Menu/SettingsButton.text = str(language["settings"])
	$Menu/QuitButton.text = str(language["quit"])
	$SettingsPanel/Title.text = str(language["settings_title"])
	$SettingsPanel/VolumeLabel.text = str(language["volume"])
	$SettingsPanel/LanguageLabel.text = str(language["language"])
	$SettingsPanel/CloseButton.text = str(language["close"])

func _start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)
