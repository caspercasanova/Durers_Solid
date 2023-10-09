extends Node3D

var resources = 0
func _physics_process(delta):
	pass


func _on_resource_drop_off_body_entered(body: Node3D) -> void:	
	if (body is Gatherer):
		body.deposit_resource()
		resources += 1
		
		print('Base got resource +1')
