
extends Node

const CONFIG_PATH = "res://../settings.cfg"

var config = ConfigFile.new()

# Valores predeterminados
var master_volume = 100
var muted = false
var fullscreen = false

# Dificultad: 0 = Facil, 1 = Normal, 2 = Dificil
var difficulty = 1

# Modo Zen
var zen_mode = false


func _ready():
	load_settings()
	apply_settings()


# Cargar configuracion
func load_settings():
	var error = config.load(CONFIG_PATH)

	if error == OK:
		master_volume = config.get_value("audio", "volume", 100)
		muted = config.get_value("audio", "muted", false)
		fullscreen = config.get_value("display", "fullscreen", false)
		difficulty = config.get_value("game", "difficulty", 1)
		zen_mode = config.get_value("game", "zen_mode", false)


# Guardar configuracion
func save_settings():
	config.set_value("audio", "volume", master_volume)
	config.set_value("audio", "muted", muted)
	config.set_value("display", "fullscreen", fullscreen)
	config.set_value("game", "difficulty", difficulty)
	config.set_value("game", "zen_mode", zen_mode)

	config.save(CONFIG_PATH)


# Aplicar todos los ajustes
func apply_settings():
	apply_volume()
	apply_mute()
	apply_fullscreen()


# Aplicar volumen
func apply_volume():
	var bus = AudioServer.get_bus_index("Master")

	if master_volume <= 0:
		AudioServer.set_bus_volume_db(bus, -80)
	else:
		var volume_db = linear2db(master_volume / 100.0)
		AudioServer.set_bus_volume_db(bus, volume_db)


# Silenciar
func apply_mute():
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, muted)


# Pantalla completa
func apply_fullscreen():
	OS.window_fullscreen = fullscreen


# Cambiar volumen
func set_volume(value):
	master_volume = int(value)
	apply_volume()
	save_settings()


# Cambiar mute
func set_muted(value):
	muted = value
	apply_mute()
	save_settings()


# Cambiar pantalla completa
func set_fullscreen(value):
	fullscreen = value
	apply_fullscreen()
	save_settings()


# Cambiar dificultad
func set_difficulty(value):
	difficulty = int(value)
	save_settings()


# Cambiar modo Zen
func set_zen_mode(value):
	zen_mode = value
	save_settings()


# Multiplicador de velocidad de los enemigos
func get_speed_multiplier():
	if difficulty == 0:
		return 0.7
	elif difficulty == 2:
		return 1.5

	return 1.0


# Tiempo entre apariciones de enemigos
func get_spawn_interval():
	if difficulty == 0:
		return 0.8
	elif difficulty == 2:
		return 0.3

	return 0.5
