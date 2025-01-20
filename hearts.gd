extends AnimatedSprite2D

signal killplayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_hpdec(newhp: int) -> void:
	frame = newhp
	if (newhp == 0):
		killplayer.emit()
