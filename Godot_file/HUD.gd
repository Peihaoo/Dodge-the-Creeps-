extends CanvasLayer

signal start_game_1P
signal start_game_2P
onready var difficulty_option = $SettingsPanel/DifficultyOption
onready var settings_panel = $SettingsPanel
onready var volume_slider = $SettingsPanel/VolumeSlider
onready var mute_button = $SettingsPanel/MuteButton
onready var fullscreen_button = $SettingsPanel/FullscreenButton
onready var zen_button = $SettingsPanel/ZenButton

func _ready():
	$SettingsPanel.hide()
	$ReturnMenu.hide()
	
	$SettingsPanel/DifficultyOption.clear()
	$SettingsPanel/DifficultyOption.add_item("Fácil")
	$SettingsPanel/DifficultyOption.add_item("Normal")
	$SettingsPanel/DifficultyOption.add_item("Difícil")

	$SettingsPanel/DifficultyOption.select(settings.difficulty)
	
	$SettingsPanel/VolumeSlider.value = settings.master_volume
	$SettingsPanel/MuteButton.set_pressed(settings.muted)
	$SettingsPanel/FullscreenButton.set_pressed(settings.fullscreen)
	$SettingsPanel/DifficultyOption.select(settings.difficulty)
	$SettingsPanel/ZenButton.set_pressed(settings.zen_mode)

func show_message(text):
	$Missatge.text = text
	$Missatge.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Espereu fins que el MessageTimer hagi acabat de comptar.
	yield($MessageTimer, "timeout")
	$Missatge.text = "Dodge the\nCreeps!"
	$Missatge.show()
	# Feu un temporitzador one-shot i espereu que acabi.
	yield(get_tree().create_timer(1), "timeout")
	$SinglePlayer.show()
	$LocalMultiPlayer.show()
	$Settings.show()
	$Exit.show()
	$ReturnMenu.hide()

func update_score_p1(scoreP1):
	$ScoreLabel.text = str(scoreP1)

func update_score_p2(scoreP2):
	$ScoreLabel2.text = str(scoreP2)

func _on_MessageTimer_timeout():
	$Missatge.hide()
	
func hide_HUD_buttons():
	$SinglePlayer.hide()
	$LocalMultiPlayer.hide()
	$Settings.hide()
	$Exit.hide()

func _on_Singleplayer_pressed():
	hide_HUD_buttons()
	
	emit_signal("start_game_1P")
	if settings.zen_mode:
		$ReturnMenu.show()

func _on_LocalMultiPlayer_pressed():
	hide_HUD_buttons()
	$ScoreLabel2.show();
	emit_signal("start_game_2P")
	if settings.zen_mode:
		$ReturnMenu.show()

func _on_Settings_pressed():
	$SettingsPanel.show()

func _on_BackButton_pressed():
	$SettingsPanel.hide()

func _on_volume_changed(value):
	settings.set_volume(value)

func _on_mute_changed(value):
	settings.set_muted(value)

func _on_fullscreen_changed(value):
	settings.set_fullscreen(value)

func _on_difficulty_changed(index):
	settings.set_difficulty(index)

func _on_zen_changed(value):
	settings.set_zen_mode(value)


func _on_Exit_pressed():
	get_tree().quit()

func _on_ReturnMenu_pressed():
	get_parent().return_to_menu()
