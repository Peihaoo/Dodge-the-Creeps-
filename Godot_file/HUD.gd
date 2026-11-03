extends CanvasLayer

signal start_game_1P
signal start_game_2P

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
	
func update_score_p1(scoreP1):
	$ScoreLabel.text = str(scoreP1)

func update_score_p2(scoreP2):
	$ScoreLabel2.text = str(scoreP2)

func _on_MessageTimer_timeout():
	$Missatge.hide()

func _on_Singleplayer_pressed():
	$SinglePlayer.hide()
	$LocalMultiPlayer.hide()
	$ScoreLabel2.hide()
	emit_signal("start_game_1P")

func _on_LocalMultiPlayer_pressed():
	$SinglePlayer.hide()
	$LocalMultiPlayer.hide()
	$ScoreLabel2.show()	
	emit_signal("start_game_2P")

func _on_Settings_pressed():
	pass # Replace with function body.
