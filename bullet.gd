extends CharacterBody2D
var vel : Vector2
var CURRENTBULLETNODE : CharacterBody2D
signal boss_hit

func _ready() -> void:
	if not (is_in_group("BULLET")):
		add_to_group("BULLET")
	CURRENTBULLETNODE = get_node(".")

func _physics_process(delta: float) -> void:
	var coll := move_and_collide(vel * delta * 300)
	
	if (coll):
		var coll_obj := coll.get_collider()
		var objName : String = coll_obj.name
		#print("obj name: ", coll_obj.name)
		if (objName == "boss"):
			boss_hit.emit()
			destroy()
		elif ("bossWall" in objName):
			#print("wall hit")
			add_collision_exception_with(coll_obj)
		else:
			#print("name: ", coll_obj.name)
			destroy()

func destroy() -> void:
	remove_from_group("BULLET")
	queue_free()
