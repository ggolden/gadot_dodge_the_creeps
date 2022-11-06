extends Node

export(PackedScene) var mob_scene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()
	$Music.stop()
	$GameOver.play()
	
func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Hud.update_score(score)
	$Hud.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

func _on_MobTimer_timeout():
	# creat a new instance
	var mob = mob_scene.instance()
	
	# choose random location along path
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	# var x = $MobPath/MobSpawnLocation
	mob_spawn_location.offset = randi()
	
	# set direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set position to random
	mob.position = mob_spawn_location.position
	
	# add randomness to direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# choose velocity
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_ScoreTimer_timeout():
	score += 1
	$Hud.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
