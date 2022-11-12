# Player.gd

extends Area2D

signal hit

export var speed = 400

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = input_velocity()
	update_animation(velocity)
	update_position(velocity, delta)

func input_velocity():
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	return velocity

func update_animation(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y  != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = false

	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func update_position(velocity, delta):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	print("hit by: " + str(body))
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
