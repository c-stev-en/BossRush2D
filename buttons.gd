extends Control

@onready var buttons : Control = $Buttons
@onready var button : Control = $Button
var lvl_instance : Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func unload_lvl():
	if (is_instance_valid(lvl_instance)):
		lvl_instance.queue_free()
	lvl_instance = null

func load_lvl(levelname : String):
	unload_lvl()
	var lvl_path : String = "res://%s.tscn" % levelname
	var lvl_src := load(lvl_path)
	if (lvl_src):
		lvl_instance = lvl_src.instantiate()
		add_child(lvl_instance)

func _on_button_pressed() -> void:
	load_lvl("lvl1")
