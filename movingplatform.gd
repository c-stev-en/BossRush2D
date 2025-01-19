extends Path2D

@onready var path_follow : PathFollow2D = $PathFollow2D
@onready var anima : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = \
$AnimatableBody2D/Sprite2D
@onready var coll_shape : CollisionShape2D = \
$AnimatableBody2D/CollisionShape2D

var loop : bool = true
var speed : float = 0.14
var spd_scale : float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anima.play("new_animation")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (sprite.global_position.y != coll_shape.global_position.y):
		sprite.global_position.y = coll_shape.global_position.y
