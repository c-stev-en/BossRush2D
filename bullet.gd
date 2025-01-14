extends CharacterBody2D
var vel : Vector2

func _ready():
	$VisibleOnScreenNotifier2D.connect("screen_exited", Callable(self, "_scex()"))
	add_to_group("BULLET")

func _physics_process(delta: float) -> void:
	var coll_info = move_and_collide(vel * delta * 300)
	
	if (coll_info) : #dont allow collision
		Destroy()

func _scex():
	Destroy()
	
func Destroy():
	remove_from_group("BULLET")
	queue_free()
