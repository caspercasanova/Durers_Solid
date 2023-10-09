extends ActionLeaf

@export var x = 10
@export var y = 0.5 # change to global maybe?
@export var z = 10


func get_new_random_Vec3(x, y, z) -> Vector3:
	return Vector3(randi_range(-x, x), y, randi_range(-z, z))

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.set_navigation_agent_target(get_new_random_Vec3(x, y, z))
	return SUCCESS

