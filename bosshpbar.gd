extends Sprite2D

var scale_x : float = 1.00
var bosshp : int = 100
var dead : bool = false

signal bossdead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_player_boss_hitt() -> void:
	if (bosshp > 0):
		bosshp -= 1
		scale_x = (bosshp * 0.01)
		scale.x = scale_x
		#print("bosshp: ", scale_x)
	else:
		if (dead == false):
			dead = true
			bossdead.emit()
