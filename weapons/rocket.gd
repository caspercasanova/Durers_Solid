extends Area3D

var start_speed = 0
var rocket_speed = 50
var dispersion_radius = 20 
# Calculate a random deviation within the dispersion radius
# var deviation = Vector3(randf(), randf(), randf()).normalized() * randf() * dispersion_radius
var fuel = 1
# Called when the node enters the scene tree for the first time.
var x_sign = 1 if randf() > 0.5 else -1
var y_sign = 1 if randf() > 0.5 else -1
var rand_x_dispersion = randf_range(5, 15) * x_sign
var rand_y_dispersion = randf_range(5, 15) * y_sign

var misfire = false if randf() > 0.05 else true

# trajectory 
var radius = 2.0  # Radius of the helix
var numSegments = 100  # Number of segments in the helix
var speed = 1.0  # Speed of traversal




 
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if(misfire):
		print('ROCKET MISFIRE')
		position -= get_transform().basis.z * rocket_speed * delta
		position -= get_transform().basis.x * rand_x_dispersion * 10 * delta
		position -= get_transform().basis.y * rand_y_dispersion * delta
	else: 
		position -= get_transform().basis.z * rocket_speed * delta
	
	fuel -= (delta * 1)
	if (fuel <= 0):
		print('Rocket ran out of fuel')
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.get_class() == "RigidBody3D" || body.get_class() == "StaticBody3D" || body.get_class() == 'CSGPrimitive3D': 
		$explosion_radius.monitoring = true
		print('Rocket Collided')
	pass # Replace with function body.


func _on_explosion_radius_body_entered(body: Node3D) -> void:
	var bodies = $explosion_radius.get_overlapping_bodies()
	for collision_body in bodies: 
		if collision_body.get_class() == "RigidBody3D":
			print('Collision_body', collision_body)
			# apply impulse to center of body relative to where they are compared to the explosion itself  with a speed of 10
			collision_body.apply_impulse(Vector3.ZERO, (collision_body.global_transform.origin - global_transform.origin ).normalized() * 10)
		queue_free()
	pass # Replace with function body
	
	
func createHelicalArc(r, pitch, incAngle):
	var alpha = incAngle * PI / 360.0  # half included angle
	var p = pitch/ (2 * PI)    # helix height per radian
	var ax = r * cos(alpha)
	var ay = r * sin(alpha)
	var b = p* alpha * (r - ax) * (3 * r - ax) / (ay * (4 * r - ax) * tan(alpha))
	var b0 = {"x": ax, "y":-ay, "z": -alpha * p}
	var b1 = {"x": (4 * r - ax) / 3, "y": -(r - ax) * (3 * r - ax) / (3 * ay), "z": -b}
	var b2 = {"x": (4 * r - ax) / 3, "y":(r - ax) * (3 * r - ax)/(3 * ay), "z":b}
	var b3 = {"x":ax, "y":ay, "z":alpha * p}
	
	return ["M", b0.x,b0.y,b0.z, "C", b1.x,b1.y,b1.z, b2.x,b2.y,b2.z, b3.x,b3.y,b3.z];
	
