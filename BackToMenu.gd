extends Sprite2D

@onready var menupath : String = "res://menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventMouseButton and event.pressed and visible:
		if(get_rect().has_point(to_local(event.position))):
			get_tree().change_scene_to_file(menupath)
