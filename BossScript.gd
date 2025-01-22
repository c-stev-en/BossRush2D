extends CharacterBody2D

@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var bosstimer : Timer = $Timer
@onready var bodybox : Area2D = $Bodybox
@onready var anima : AnimatedSprite2D = $AnimatedSprite2D
@onready var wingmid : CollisionPolygon2D = $Bodybox/WingmidPolygon
@onready var Player : CharacterBody2D = get_tree().\
	get_first_node_in_group("Player")
@onready var bossWall_L : StaticBody2D = get_tree().\
	get_first_node_in_group("bossWall_left")
@onready var bossWall_R : StaticBody2D = get_tree().\
	get_first_node_in_group("bossWall_right")
@onready var audio_wing : AudioStreamPlayer2D = get_tree().\
	get_first_node_in_group("audio_wing")
@onready var audio_atkcall : AudioStreamPlayer2D = get_tree().\
	get_first_node_in_group("audio_atkcall")
@onready var audio_clownbg : AudioStreamPlayer2D = get_tree().\
	get_first_node_in_group("audio_clownbg")
var speed : float = 100.0
var spin_speed : int = 220 
var dir : int = 1
var value : int = 0
var spin : bool = false
var atk : bool = false
var waiter1 : bool = true
var dead : bool = false
var collider : Object
var coll : bool
var nodelay : bool = false
var temp_playerpos : Vector2
var temp_bosspos : int
var framecount : int = 0

signal valid(val : int)
signal hit_player

func _ready() -> void:
	add_collision_exception_with(Player)
	anima.play("look")
	anima.flip_h = false
	rng.seed = Time.get_ticks_msec()
	bosstimer.start()

func _physics_process(delta: float) -> void:
	if (atk == false):
		if !(spin):
			velocity.x = dir * speed
			coll = move_and_slide()
			if (global_position.y != 110):
				global_position.y = 110
		else:
			global_position = global_position.move_toward(\
				Vector2(temp_bosspos, 110), delta * spin_speed)
			rotation -= 11 * delta
			if (global_position.distance_to(\
				Vector2(temp_bosspos, 110)) <= 8 && rotation < 1.0):
				#print("Val: ", value, ", Nodelay: ", nodelay, ", Spin: ", spin)
				remove_collision_exception_with(bossWall_L)
				remove_collision_exception_with(bossWall_R)
				speed = 100.0
				anima.play("look")
				#print("timer start")
				bosstimer.start()
				rotation = 0.0
				spin = false
			if (framecount == 5):
				audio_wing.play()
	
		if (coll):
			for i in get_slide_collision_count():
				var collision := get_slide_collision(i)
				collider = collision.get_collider()
		
		if (framecount == 6):
			if (position.y != 110 or (!(rotation < 1.0))) and !spin:
				position.y = 110
				speed = 2.0
				rotation = max(rotation - (21.0 * delta), 0.0)
				anima.frame = 1
			if (anima.frame == 2):
				audio_wing.play()
			framecount = 0
	
		if is_on_wall() and ("bossWall" in collider.name) and !spin:
			flip_dir()
		
		#GET NEW RNG EVERY SECOND
		if (Engine.get_process_frames() % 60 == 0 \
			and !spin and nodelay and speed > 0.0):
			if (waiter1):
				value = rng.randi_range(3, 7)
				print("atk val: ", value)
			if (value == 7 and !atk):
				waiter1 = false
				spin_atk(delta)
				#print("Attack call, waiter1 : ", waiter1)
			#print("newvalue: ", value)
		
	elif (atk == true):
		if (global_position.distance_to(temp_playerpos) > 8):
			global_position = global_position.move_toward(\
			temp_playerpos, delta * spin_speed)
			
			rotation += 11 * delta
		if (global_position.distance_to(temp_playerpos) <= 8 and atk) :
			await get_tree().create_timer(0.4, true, false, true).timeout
			atk = false
		if (framecount == 6):
			audio_wing.play()
			framecount = 0
		
	if (rotation < 0.0): #failsafe
		print("rotate: ", rotation)
		rotation = float(0.0)
	
	#I LOVE FAILSAFES	
	if (framecount == 4):
		if (get_tree().get_node_count_in_group("Player") == 0):
			if (speed > 0.0):
				speed = 0.0
		if (anima.frame != 1 and speed != 100.0): 
			speed = 100.0
	
	
	framecount += 1

func flip_dir() -> void:
	dir *= -1
	anima.flip_h = (dir < 0)
	#print(dir)
	
func spin_atk(delta : float) -> void:
	add_collision_exception_with(bossWall_L)
	add_collision_exception_with(bossWall_R)
	anima.stop()
	anima.frame = 1
	audio_atkcall.pitch_scale = rng.randf_range(0.94, 1.06)
	audio_atkcall.play()
	speed = 0.0
	await get_tree().create_timer(1).timeout
	spin = true
	atk = true
	value = 0
	nodelay = false
	temp_playerpos = Player.global_position
	temp_bosspos = global_position.x
	valid.emit(0)
	#print("NO DELAY: ", nodelay)
 
func _on_timer_timeout() -> void:
	value = 0
	nodelay = true
	waiter1 = true
	valid.emit(1) #1 = FRAME1
	#print("timer end, Nodelay: ", nodelay, ", waiter1: ", waiter1)

func _on_bodybox_body_entered(body: Node2D) -> void:
	if (bodybox.overlaps_body(Player) and dead == false):
		hit_player.emit()

func _on_animated_sprite_2d_frame_changed() -> void:
	pass

func _on_boss_hp_bar_bossdead() -> void:
	dead = true
	speed = 0.0
	value = 0
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_hearts_killplayer() -> void:
	dead = true
	speed = 0.0
	value = 0
