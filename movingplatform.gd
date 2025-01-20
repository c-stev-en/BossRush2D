extends Path2D

@onready var anima : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anima.play("new_animation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if (sprite.global_position.y != coll_shape.global_position.y):
		#sprite.global_position.y = coll_shape.global_position.y

func _on_boss_hp_bar_bossdead() -> void:
	anima.stop()

func _on_hearts_killplayer() -> void:
	anima.stop()
