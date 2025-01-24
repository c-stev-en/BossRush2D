extends Node2D

@onready var play_button : Button = $PlayButton
@onready var controls_button : Button = $ControlsButton
@onready var load : Label = $Load
@onready var cbox_spriteArr : Array[AnimatedSprite2D] = \
	[$checkbox1/box_sprite, $checkbox2/box_sprite, $checkbox3/box_sprite, \
	 $checkbox4/box_sprite, $checkbox5/box_sprite]
@onready var cbox_group : Array[CharacterBody2D] = \
	[$checkbox1, $checkbox2, $checkbox3, $checkbox4, $checkbox5]
@onready var mod_lbls : Array[Label] = [$DoubleHP, $OneHeart, \
	$NoDoubleJump, $LessAmmo, $Kneecapped]
@onready var exit_button : CharacterBody2D = $exit_button
@onready var begin_button : StaticBody2D = $begin_button
@onready var gamepath : String = "res://game_scene.tscn"
@onready var controlspath : String = "res://settings.tscn"
@onready var ModLabel : Label = $Label
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var checkclick : AudioStreamPlayer2D = $audio_Check_Click
@onready var aud_openmenu : AudioStreamPlayer2D = $audio_openmenu
@onready var aud_closemenu : AudioStreamPlayer2D = $audio_closemenu

var checked : Array[bool] = [false, false, false, false, false]
var framecount : int = 0
var sec_count : int = 60
var xy_load : int = 0
var checkbox_loader : int = 0
var checkbox_unloader : int = 0
var checkclickpitch : float = 1.000
var pitch2 : float = 1.000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load.visible = false
	ModLabel.visible = false
	exit_button.visible = false
	begin_button.visible = false
	cbox_spriteArr[0].stop()
	cbox_spriteArr[1].stop()
	cbox_spriteArr[2].stop()
	cbox_spriteArr[3].stop()
	cbox_spriteArr[4].stop()
	
	while xy_load < 5:
		cbox_group[xy_load].visible = false
		mod_lbls[xy_load].visible = false
		xy_load += 1
		
	play_button.visible = true
	controls_button.visible = true
	
	rng.seed = Time.get_ticks_msec()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (sec_count < 60):
		sec_count += 1
	else:
		checkclickpitch = rng.randf_range(0.820, 1.080)
		pitch2 = rng.randf_range(0.940, 1.060)
		checkclick.pitch_scale = checkclickpitch
		aud_closemenu.pitch_scale = pitch2 - 0.10
		aud_openmenu.pitch_scale = pitch2 + 0.10
		sec_count = 0

func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file(controlspath)

func _on_play_button_pressed() -> void:
	if (play_button.visible and checkbox_loader == 0):
		aud_openmenu.play()
		setupCheckbox()
	
func setupCheckbox() -> void:
	play_button.visible = false
	controls_button.visible = false
	ModLabel.visible = true
	
	while checkbox_loader < 5:
		cbox_group[checkbox_loader].visible = true
		mod_lbls[checkbox_loader].visible = true
		checkbox_loader += 1
		
	checkbox_unloader = 0
	exit_button.visible = true
	begin_button.visible = true
		
func resetCheckbox() -> void:
	ModLabel.visible = false
	
	while checkbox_unloader < 5:
		cbox_group[checkbox_unloader].visible = false
		mod_lbls[checkbox_unloader].visible = false
		checked[checkbox_unloader] = false
		checkbox_unloader += 1
		
	play_button.visible = true
	controls_button.visible = true
	checkbox_loader = 0
	exit_button.visible = false
	begin_button.visible = false

func _on_checkbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and cbox_group[0].visible:
		checkclick.play()
		if (checked[0] == false):
			cbox_spriteArr[0].frame = 1
			checked[0] = true
		else:
			cbox_spriteArr[0].frame = 0
			checked[0] = false

func _on_checkbox_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and cbox_group[1].visible:
		checkclick.play()
		if (checked[1] == false):
			cbox_spriteArr[1].frame = 1
			checked[1] = true
		else:
			cbox_spriteArr[1].frame = 0
			checked[1] = false

func _on_checkbox_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and cbox_group[2].visible:
		checkclick.play()
		if (checked[2] == false):
			cbox_spriteArr[2].frame = 1
			checked[2] = true
		else:
			cbox_spriteArr[2].frame = 0
			checked[2] = false

func _on_checkbox_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and cbox_group[3].visible:
		checkclick.play()
		if (checked[3] == false):
			cbox_spriteArr[3].frame = 1
			checked[3] = true
		else:
			cbox_spriteArr[3].frame = 0
			checked[3] = false

func _on_checkbox_5_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and cbox_group[4].visible:
		checkclick.play()
		if (checked[4] == false):
			cbox_spriteArr[4].frame = 1
			checked[4] = true
		else:
			cbox_spriteArr[4].frame = 0
			checked[4] = false

func _on_exit_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed \
		and exit_button.visible and checkbox_unloader == 0:
		aud_closemenu.play()
		resetCheckbox()

func _on_begin_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed \
		and begin_button.visible and checkbox_unloader == 0:
		load.visible = true
		Global.modifiers = [checked[0], checked[1], \
			checked[2], checked[3], checked[4]]
		await get_tree().create_timer(0.01).timeout
		get_tree().change_scene_to_file(gamepath)
