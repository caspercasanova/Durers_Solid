extends Node3D

var resource_per_second = 1


func _ready() -> void:
	pass


func _physics_process(delta):
	pass


func _on_resource_zone_body_entered(body: Node3D) -> void:
	if (body is Gatherer):
		body.gather_resource()
		print("I Gave a resource")
	pass 
