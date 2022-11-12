extends Node

export(PackedScene) var mob_scene

var score

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Hud.update_score(score)
	$Hud.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()
	$Music.stop()
	$GameOver.play()

func _on_MobTimer_timeout():
	# creat a new instance
	var mob = mob_scene.instance()
	
	# use the path to place the mob
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	# var mob_spawn_location = $MobPath/MobSpawnLocation
	
	# place it on a random part of the path
	mob_spawn_location.offset = randi()
	mob.position = mob_spawn_location.position
	
	# set direction perpendicular to the path direction,
	# with some randomness
	var direction = (mob_spawn_location.rotation + PI / 2)
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
		
	# choose velocity from range
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$Hud.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
