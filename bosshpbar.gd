extends Sprite2D

var scale_x : float = 1.00
var bosshp : int = 50
var doublehp : bool = false
var dead : bool

@onready var audio_hitboss : AudioStreamPlayer2D = get_tree().\
	get_first_node_in_group("audio_hitboss")
@onready var audio_clownbg : AudioStreamPlayer2D = get_tree().\
	get_first_node_in_group("audio_clownbg")

signal bossdead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead = false
	audio_clownbg.play()
	
	if (Global.modifiers[0]):
		doublehp = true
		bosshp = 100

func _on_player_boss_hitt() -> void:
	if (bosshp > 0):
		bosshp -= 1
		if (doublehp):
			scale_x = (bosshp * 0.01)
		else:
			scale_x = (bosshp * 0.02)
		scale.x = scale_x
		audio_hitboss.play()
	else:
		if (dead == false):
			bossdead.emit()
			dead = true

func _on_audio_clownbg_finished() -> void:
	if (bosshp > 0):
		audio_clownbg.play()
