extends RigidBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var start: Area3D = %Start
@onready var end: Area3D = %End
@onready var collision_checker: RayCast3D = %laser

@export var LiftPointDistance: float = 1.0 # meters ahead of center of mass


var last_linear_velocity = null
var last_angular_velocity = null
var lift_intensity = 6.0

# https://www.reddit.com/r/godot/comments/mqp29g/comment/hddil1b/?utm_source=share&utm_medium=web2x&context=3

var target_destination: Vector3

var angle := randf_range(45, 135)
func random_point_between_vectors(vector1, vector2):
	# Find the minimum and maximum boundaries for each dimension
	var min_x = min(vector1.x, vector2.x)
	var max_x = max(vector1.x, vector2.x)

	var min_y = min(vector1.y, vector2.y)
	var max_y = max(vector1.y, vector2.y)

	var min_z = min(vector1.z, vector2.z)
	var max_z = max(vector1.z, vector2.z)

	# Generate random values within the range of each dimension
	var random_x = randi_range(min_x - 5, max_x + 5)
	var random_y = randi_range(min_y - 5 , max_y + 5)
	var random_z = randi_range(min_z - 5, max_z + 5)

	# Create a new Vector3 point
	var random_point = Vector3(random_x, random_y, random_z)

	return random_point




var current_destination: Vector3
var future_waypoints: Array[Vector3] = []
var max_number_of_waypoints = 5


func actor_at_destination(actor: Node, destination: Vector3, threshold: int) -> bool:
	return threshold >= actor.global_position.distance_to(destination)

func set_new_destination(actor, destination):
	if !future_waypoints.size():
		populate_way_points(actor, destination)	
	
	current_destination = future_waypoints.pop_front()

func populate_way_points(actor: Node, destination: Vector3):
	var new_waypoints: Array[Vector3] = []
	var new_waypoint = random_point_between_vectors(actor.global_position, destination)
	new_waypoints.append(new_waypoint)
	new_waypoints.append(random_point_between_vectors(new_waypoints[new_waypoints.size() - 1], destination))
	new_waypoints.append(random_point_between_vectors(new_waypoints[new_waypoints.size() - 1], destination))
	new_waypoints.append(random_point_between_vectors(new_waypoints[new_waypoints.size() - 1], destination))
	new_waypoints.append(random_point_between_vectors(new_waypoints[new_waypoints.size() - 1], destination))
	future_waypoints = new_waypoints
	pass



func _ready():
	target_destination = end.global_position

	pass





func _physics_process(delta: float) -> void:
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta
	if(actor_at_destination(self, target_destination, 1)):
		set_new_destination(self, target_destination)

#	print(current_destination)
	
	var next_path_position: Vector3 = current_destination
	var new_velocity: Vector3 = (next_path_position - global_position).normalized() * SPEED
	
	
	
	
#
	var up_vector = global_transform.basis.y # roof of plane on global frame
#	var forward_vector = -global_transform.basis.z # nose of plane in global frame
#	var right_vector = global_transform.basis.x # right wing of plane in global frame
##
##	# Both are in global coordinates
#	var linear_acceleration = (linear_velocity - last_linear_velocity) / delta if last_linear_velocity != null else Vector3.ZERO
#	var angular_acceleration = (angular_velocity - last_angular_velocity) / delta if last_angular_velocity != null else Vector3.ZERO
#
#	# ================
#	# LIFT
#
	var lift_vector = up_vector * lift_intensity * delta
#	apply_force(lift_vector, forward_vector * LiftPointDistance)
#	apply_force(lift_vector)
	add_constant_central_force (lift_vector) 
	
	
#	move_and_slide()



#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis * Vector3(0, 0, 1)
#	var target_dir = (target_position - current_transform.origin).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))
#
#func _integrate_forces(state):
#	var target_position = end.global_transform.origin
#	look_follow(state, global_transform, target_position)
#	apply_central_force(Vector3(0,0,5))


#
#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis * Vector3(0, 0, 1)
#	var target_dir = (target_position - current_transform.origin).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#
#	state.angular_velocity = up_dir * (rotation_angle / state.step)
#
#func _integrate_forces(state):
#	var target_position = end.global_transform.origin
#	look_follow(state, global_transform, target_position)





func get_random_vector(xmin := 0.0, xmax := 1.0, ymin := 0.0, ymax := 0.0, zmin := 0, zmax := 1) -> Vector3:
	return Vector3(randf_range(xmin, xmax), randf_range(ymin, ymax), randf_range(zmin, zmax))




func get_random_pos_in_sphere (radius : float) -> Vector3:
	var x1 = randi_range(-1, 1)
	var x2 = randi_range(-1, 1)
	
	while (x1 * x1) + (x2 * x2) >= 1:
		x1 = randi_range (-1, 1)
		x2 = randi_range (-1, 1)
	
	var random_pos_on_unit_sphere = Vector3 (
	2 * x1 * sqrt (1 - x1*x1 - x2*x2),
	2 * x2 * sqrt (1 - x1*x1 - x2*x2),
	1 - 2 * (x1*x1 + x2*x2))
	
	return random_pos_on_unit_sphere * randi_range (0, radius)





# Define the maximum number of iterations
var max_iterations = 1000

# Define the step size for growing the BIT* tree
var step_size = 1.0


func randomVectorInCylinder(radius: float, height: float) -> Vector3:
	# Step 1: Random angle between 0 and 2*pi
	var theta = randf() * 2 * PI

	# Step 2: Random height between 0 and cylinder height
	var h = randf() * height

	# Step 3: Calculate x, y, and z coordinates
	var x = radius * cos(theta)
	var y = radius * sin(theta)
	var z = h

	return Vector3(x, y, z)






func isVectorInRange(vector_to_check: Vector3, target: Vector3, range: int) -> bool:
	# Calculate the distance between the origin and the vector to check.
	var distance = vector_to_check.distance_to(target)
	
	# Check if the distance is less than or equal to the specified range.
	return distance <= range
	



func radius(a, b, theta):
	return a * b / sqrt((b * cos(theta))**2 + (a* sin(theta))**2)




