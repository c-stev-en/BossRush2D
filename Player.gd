extends CharacterBody2D
const bulletpath = preload("res://bullet.tscn")
const SPEED : float = 180.0
const JUMP_VELOCITY : float = -500.0
var bulletpos : Vector2
var jumpct : int = 1
var dir
var bulletct : int = 0
signal bossHitt
signal new_bullet(bullet_node : CharacterBody2D)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if (jumpct == 2):
			jumpct = 1
	else:
		jumpct = 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (jumpct > 0):
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("ui_shoot"):
		bulletct = get_tree().get_nodes_in_group("BULLET").size()
		print("bulletct: ", bulletct)
		if (bulletct < 5):
			shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions witwh custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Set shooting direction upon change
	if (Engine.get_process_frames() % 4 == 0):
		if (direction == -1 and dir != -1):
			dir = -1
		if (direction == 1 and dir != 1):
			dir = 1
	
	# CHECK FOR COLLISION WITH BOSS WALLS
	# CHECKS IF GROUND HAS SPRITE2D FOR COLLISION
	for i in range(get_slide_collision_count()):
		var collision_info = get_slide_collision(i)
		if collision_info:
			var collider = collision_info.get_collider()
			if not collider or not (collider.has_node("Sprite2D") or collider.has_node("AnimatedSprite2D")):
				add_collision_exception_with(collider)
				
	move_and_slide()

func shoot() -> void:
	var bullet = bulletpath.instantiate()
	if (dir == 1):
		bulletpos = Vector2(30, 0)
		bullet.vel = Vector2(1.5, 0)
	else:
		bulletpos = Vector2(-30, 0)
		bullet.vel = Vector2(-1.5, 0)
	
	get_parent().add_child(bullet)
	bullet.boss_hit.connect(bossHit)
	bullet.position = ($Sprite2D.global_position + bulletpos)

func bossHit() -> void:
	bossHitt.emit()
