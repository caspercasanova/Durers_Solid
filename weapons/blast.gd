extends Damage_Source.Blast


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# play animations 
	pass


func _on_body_entered(body: Node3D) -> void:
	print('From within the explosion', body)
	pass # Replace with function body.
