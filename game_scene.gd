extends Node2D
 
@onready var boss : CharacterBody2D = $boss
@onready var player : CharacterBody2D = $Player
@onready var backdrop : Sprite2D = $backdrop
@onready var pos_x : int = backdrop.global_position.x
@onready var pos_y : int = backdrop.global_position.y
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var framecount : int = 0
var shake : bool = true
var boss_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.seed = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if	(framecount == 41 and shake == true):
		backdrop.global_position.x = rng.randi_range(\
			pos_x - 1,\
			pos_x + 1)
		backdrop.global_position.y = rng.randi_range(\
			pos_y - 1,\
			pos_y + 1)
		framecount = 0
	elif (shake == true):
		framecount += 1
	else: #(shake == false)
		if (boss_over == false):
			BossOver()

func _on_boss_hp_bar_bossdead() -> void:
	if (shake == true):
		shake = false

func _on_hearts_killplayer() -> void:
	if (shake == true):
		shake = false
	
func BossOver() -> void:
	boss_over = true
	shake = false
	backdrop.global_position.x = pos_x
	backdrop.global_position.y = pos_y
	framecount = 0
