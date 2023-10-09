extends SpringArm3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # make mouse invisible 
	# $humber_camera.add_exception(get_parent()) # prevent camera from getting stuck behind model
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	# toggle_mouse_mode  
	if Input.is_action_just_pressed('ESC'):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * 0.1, -45, 45)
			rotation_degrees.y -= event.relative.x * 0.1 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
