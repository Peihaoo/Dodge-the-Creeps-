extends Node
export(PackedScene) var mob_scene
var scoreP1
var scoreP2
var p1Over = false
var p2Over = false
var singleplayer = false

func _ready():
	randomize()

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()

func new_game_1P():
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$HUD.show_message("Get Ready")
	scoreP1 = 0
	p2Over = true
	p1Over = false
	$HUD.update_score_p1(scoreP1)
	$Player.start($StartPosition.position)
	singleplayer = true
	$StartTimer.start()

func new_game_2P():
	get_tree().call_group("mobs", "queue_free")
	$Music.play()
	$HUD.show_message("Get Ready")
	scoreP1 = 0
	scoreP2 = 0
	p1Over = false
	p2Over = false
	$HUD.update_score_p1(scoreP1)
	$HUD.update_score_p2(scoreP2)
	$Player.start($StartPosition.position)
	$Player2.start($StartPosition_p2.position)
	singleplayer = false
	$StartTimer.start()

func _on_MobTimer_timeout():
	# Crea una nova instància de l'escena Mob.
	var mob = mob_scene.instance()
	# Trieu una ubicació aleatòria a Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	# Estableix la direcció de la multitud perpendicular a la direcció del camí.
	var direction = mob_spawn_location.rotation + PI / 2
	# Estableix la posició de la multitud a una ubicació aleatòria.
	mob.position = mob_spawn_location.position
	# Afegeix una mica d'aleatorietat a la direcció.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Tria la velocitat de la multitud.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	velocity *= settings.get_speed_multiplier()
	mob.linear_velocity = velocity.rotated(direction)
	# Va fer que la multitud s'afegís a l'escena principal.
	add_child(mob)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	$ScoreTimer_p2.start()

func _on_ScoreTimer_timeout():
	if !settings.zen_mode:
		scoreP1 += 1
		$HUD.update_score_p1(scoreP1)

func _on_ScoreTimer_p2_timeout():
	if !settings.zen_mode:
		if !singleplayer:
			scoreP2 += 1
			$HUD.update_score_p2(scoreP2)

func p2_game_over():
	$DeathSound.play()
	$ScoreTimer_p2.stop()
	p2Over = true
	
	if (p1Over && p2Over):
		game_over();


func p1_game_over():
	$DeathSound.play()
	$ScoreTimer.stop()
	p1Over = true
	
	if (p1Over && p2Over):
		game_over();

func return_to_menu():
	$MobTimer.stop()
	$ScoreTimer.stop()
	$ScoreTimer_p2.stop()
	$StartTimer.stop()

	get_tree().call_group("mobs", "queue_free")
	$Music.stop()

	$HUD.show_game_over()


