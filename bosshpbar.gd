extends Sprite2D
var scale_x : float = 1.00
var bosshp : int = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_player_boss_hitt() -> void:
	bosshp -= 1
	scale_x = (bosshp * 0.01)
	scale.x = scale_x
	print("bosshp: ", bosshp)
