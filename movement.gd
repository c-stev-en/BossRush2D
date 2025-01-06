extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var jct : int = 0 #Cannot jump until touching floor first


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
		velocity.y = JUMP_VELOCITY
		jct -= 1 #remove a jump if jumping

	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
