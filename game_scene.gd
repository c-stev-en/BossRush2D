extends Node2D
 
@onready var boss : CharacterBody2D = $boss
@onready var player : CharacterBody2D = $Player
@onready var backdrop : Sprite2D = $backdrop
@onready var audio_shoot : AudioStreamPlayer2D = $audio_shoot
@onready var audio_dmg : AudioStreamPlayer2D = $audio_dmg
@onready var audio_wing : AudioStreamPlayer2D = $audio_wing
@onready var audio_jmp : AudioStreamPlayer2D = $audio_jump
@onready var audio_hitboss : AudioStreamPlayer2D = $audio_hitboss
@onready var audio_clownbg : AudioStreamPlayer2D = $audio_clownbg
@onready var LMPlatAnim : AnimationPlayer = $Moving_L/AnimationPlayer
@onready var RMPlatAnim : AnimationPlayer = $Moving_R/AnimationPlayer
@onready var result : Label = $result
@onready var rest : Button = $Button
@onready var pos_x : int = backdrop.global_position.x
@onready var pos_y : int = backdrop.global_position.y
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var framecount : int = 0
var frames2 : int = 0
var volchg : int = 1
var shake : bool = true
var boss_over : bool = false
var audiopitch : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rest.visible = false
	result.visible = false
	rng.seed = Time.get_ticks_msec()
	LMPlatAnim.play("new_animation")
	RMPlatAnim.play("new_animation")

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
		audiopitch = rng.randf_range(0.80, 1.21)
		audio_shoot.pitch_scale = (float(audiopitch - 0.03))
		audio_dmg.pitch_scale = (float(audiopitch + 0.03))
		audio_wing.pitch_scale = audiopitch
		audio_jmp.pitch_scale = float(audiopitch - 0.02)
		audio_hitboss.pitch_scale = float(audiopitch + 0.02)
	elif (shake == true):
		framecount += 1
	else:
		if (boss_over == false):
			BossOver()
		if (boss_over == true):
			if (frames2 == 6 and volchg < 50):
				audio_clownbg.set_volume_db(\
					audio_clownbg.get_volume_db() - 1.0)
				volchg += 1
				frames2 = 0
			if (volchg >= 50 and audio_clownbg.playing):
				audio_clownbg.stop()
				bossdone()
			frames2 += 1

func _on_boss_hp_bar_bossdead() -> void:
	if (shake == true):
		result.text = "YOU WIN!"
		result.global_position.x = 452
		platsDone()

func _on_hearts_killplayer() -> void:
	if (shake == true):
		result.global_position.x = 444
		platsDone()
	
func bossdone() -> void:
	result.visible = true
	rest.visible = true

func platsDone() -> void:
	shake = false
	LMPlatAnim.stop()
	RMPlatAnim.stop()
	
func BossOver() -> void:
	boss_over = true
	shake = false
	backdrop.global_position.x = pos_x
	backdrop.global_position.y = pos_y
	framecount = 0

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
