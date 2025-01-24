extends CharacterBody2D

var setting : int = 0
var controls : Array = ["Left", "Right", "Jump", "Shoot"]
var ui_ctrls: Array = ["ui_left", "ui_right", "ui_jump", "ui_shoot"]
var framecount : int = 0
var ready2 : bool = false
var last_input : String

@onready var label : Label = $Label
@onready var input_track : InputEventKey = InputEventKey.new()
@onready var menupath : String = "res://menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setting = 0
	label.text = "Press " + controls[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (framecount < 10 and ready2 == false):
		framecount += 1
	elif (framecount >= 10 and ready2 == false):
		ready2 = true
		framecount = 0
			
func _input(event) -> void:
	if (ready2):
		if (event is InputEventKey && event.pressed):
			ready2 = false
			InputMap.action_erase_events(ui_ctrls[setting])
			InputMap.action_add_event(ui_ctrls[setting], event)
			setting += 1
			if (setting < 4):
				label.text = "Press " + controls[setting]
			if (setting == 4):
				setting = 0
				get_tree().change_scene_to_file(menupath)
