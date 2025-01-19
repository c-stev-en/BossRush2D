extends CharacterBody2D

@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var speed : float = 100.0
@onready var spin_speed : int = 220 
@onready var dir : int = 1
@onready var value : int = 0
@onready var bosstimer : Timer = $Timer
@onready var bodybox : Area2D = $Bodybox
@onready var anima : AnimatedSprite2D = $AnimatedSprite2D
@onready var wingdown : CollisionPolygon2D = $Bodybox/WingdownPolygon
@onready var wingmid : CollisionPolygon2D = $Bodybox/WingmidPolygon
@onready var wingup : CollisionPolygon2D = $Bodybox/WingupPolygon
@onready var Player : CharacterBody2D = get_tree().\
	get_first_node_in_group("Player")
@onready var bossWall_L : StaticBody2D = get_tree().\
	get_first_node_in_group("bossWall_left")
@onready var bossWall_R : StaticBody2D = get_tree().\
	get_first_node_in_group("bossWall_right")
@onready var spin : bool = false
@onready var atk : bool = false
@onready var waiter1 : bool = true
var collider : Object
var coll : bool
var nodelay : bool = false
var temp_playerpos : Vector2
var temp_bosspos : int

func _ready() -> void:
	add_collision_exception_with(Player)
	update_hitbox_frame(0)
	anima.play("look")
	anima.flip_h = false
	rng.seed = Time.get_ticks_msec()
	bosstimer.start()

func _physics_process(delta: float) -> void:
	if (atk == false):
		if !(spin):
			velocity.x = dir * speed
			coll = move_and_slide()
		else:
			global_position = global_position.move_toward(\
				Vector2(temp_bosspos, 110), delta * spin_speed)
			rotation -= 4 * delta
			if (global_position.distance_to(\
				Vector2(temp_bosspos, 110)) <= 8):
				#print("Val: ", value, ", Nodelay: ", nodelay, ", Spin: ", spin)
				remove_collision_exception_with(bossWall_L)
				remove_collision_exception_with(bossWall_R)
				speed = 100.0
				anima.play("look")
				#print("timer start")
				bosstimer.start()
				spin = false
	
		if (coll):
			for i in get_slide_collision_count():
				var collision := get_slide_collision(i)
				collider = collision.get_collider()
		
		if (position.y != 110 or rotation != 0) and !spin:
			position.y = 110
			rotation = max(rotation - (7 * delta), 0)
	
		if is_on_wall() and ("bossWall" in collider.name) and !spin:
			flip_dir()
		
		#GET NEW RNG EVERY SECOND
		if (Engine.get_process_frames() % 60 == 0 and !spin and nodelay):
			if (waiter1):
				value = rng.randi_range(0, 10)
			if (value == 10 and !atk):
				spin_atk(delta)
				waiter1 = false
				#print("Attack call, waiter1 : ", waiter1)
			#print("newvalue: ", value)
		
	if (atk == true):
		if (global_position.distance_to(temp_playerpos) > 8):
			global_position = global_position.move_toward(\
			temp_playerpos, delta * spin_speed)
			
			rotation += 4 * delta
		if (global_position.distance_to(temp_playerpos) <= 8 and atk) :
			await get_tree().create_timer(0.4, true, false, true).timeout
			atk = false

func flip_dir() -> void:
	dir *= -1
	anima.flip_h = (dir < 0)
	#print(dir)
	
func spin_atk(delta : float) -> void:
	add_collision_exception_with(bossWall_L)
	add_collision_exception_with(bossWall_R)
	anima.stop()
	anima.frame = 1
	speed = 0.0
	await get_tree().create_timer(1).timeout
	spin = true
	atk = true
	value = 0
	nodelay = false
	temp_playerpos = Player.global_position
	temp_bosspos = global_position.x
	#print("NO DELAY: ", nodelay)

func _on_timer_timeout() -> void:
	value = 0
	nodelay = true
	waiter1 = true
	#print("timer end, Nodelay: ", nodelay, ", waiter1: ", waiter1)

func _on_bodybox_body_entered(body: Node2D) -> void:
	if (bodybox.overlaps_body(Player)):
		print("Player in me")

func _on_animated_sprite_2d_frame_changed() -> void:
	update_hitbox_frame(anima.frame)
	
func update_hitbox_frame(frame : int) -> void:
	match frame:
		0:
			set_polygons(false, true, true)
			print("frame0")
		1, 3:
			set_polygons(true, false, true)
			print("frame1/3")
		2:
			set_polygons(true, true, false)
			print("frame2")
		_:
			print("neither")
	
	
func set_polygons(w_up : bool, w_mid : bool, w_dwn : bool) -> void:
	wingup.disabled = w_up
	wingmid.disabled = w_mid
	wingdown.disabled = w_dwn


func _on_boss_hp_bar_bossdead() -> void:
	queue_free()
