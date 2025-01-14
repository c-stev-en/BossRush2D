extends CharacterBody2D
const bulletpath = preload("res://bullet.tscn")
const norm_speed : float = 200.0
const jvel : float  = -400.0
var bulletpos : Vector2
var jct : int = 1 #Airborne to start
var direction : String = "LEFT"
var bulletct : int = 0

func _physics_process(delta: float) -> void:
	
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		if (jct == 2) : #Single jump when falling
			jct = 1
	else: 				#Since the check fails, must be on ground
		jct = 2			#So 2 jumps
	
	# Handle jumps
	if Input.is_action_just_pressed("ui_jump") and (jct > 0):
		velocity.y = jvel
		jct -= 1 #remove a jump if jumping
	
	if Input.is_action_just_pressed("ui_shoot") and (bulletct < 5):
		shoot()
	
	# Get the input direction and handle the movement/deceleration
	var dir := Input.get_axis("ui_left", "ui_right")
	if dir:
		velocity.x = dir * norm_speed
	else:
		velocity.x = move_toward(velocity.x, 0, norm_speed)
	
	if (Engine.get_process_frames() % 4 == 0) : #Check for total bullets
		if (dir == -1 and direction != "LEFT"):
			direction = "LEFT"
		if (dir == 1 and direction != "RIGHT"):
			direction = "RIGHT"
		bulletct = get_tree().get_nodes_in_group("BULLET").size()
	
	move_and_slide()

func shoot():
	var bullet = bulletpath.instantiate()

	if (direction == "RIGHT"):
		bulletpos = Vector2(30, 0)
		bullet.vel = Vector2(1.5, 0)
	else:
		bulletpos = Vector2(-30, 0)
		bullet.vel = Vector2(-1.5, 0)
	
	get_parent().add_child(bullet)
	bullet.position = ($Sprite2D.global_position + bulletpos)
