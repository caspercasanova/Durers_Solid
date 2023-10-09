extends CharacterBody3D




const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var start: Area3D = %Start
@onready var end: Area3D = %End
@onready var collision_checker: RayCast3D = %laser
# https://www.reddit.com/r/godot/comments/mqp29g/comment/hddil1b/?utm_source=share&utm_medium=web2x&context=3

var curr_position = Vector3(0, 0, 0)
var parent = null
var cost = 0

var target_destination: Vector3 = get_random_vector(-1, 1, -1, 1, -1, 1)
var target_met = false 

var movement_speed = 5

var node := {
	curr_position: Vector3(0, 0, 0),
	parent: null,
	cost: 0,
}
# Create a list to store BIT* nodes
var nodes: Array[Vector3] = []

# Add the initial node with the starting position
var start_vec: Vector3 
# Define the goal position
var goal_vec: Vector3 


var current_target: Vector3


# Your set of vectors (replace with your data)
var vectors = [Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1)]




func _ready():
	var pos = global_position
	var delta_t = 0.01
	var trajectory: Array[Vector3] = []


	goal_vec = %End.position
	start_vec = %Start.position
	
	var midpoint = goal_vec + start_vec / 2

	for n in range(30):
		add_child(Draw3d.draw_sphere(random_point_between_vectors(start_vec, goal_vec)))
	
	current_target = midpoint
	
	
		# Process vectors and create the trajectory
	for vector in vectors:
		# Integrate vectors to update position
		pos += vector * delta_t

		# Store the current position
		trajectory.append(position)

	# Visualization (Optional)
	# Create a Line3D node to visualize the trajectory
	var line = Draw3d.create_line(trajectory)

	# Set the Line3D's points based on the trajectory
	for point in trajectory:
		line.add_point(point)
	
	pass
	

func get_random_vector(xmin := 0.0, xmax := 1.0, ymin := 0.0, ymax := 0.0, zmin := 0, zmax := 1) -> Vector3:
	return Vector3(randf_range(xmin, xmax), randf_range(ymin, ymax), randf_range(zmin, zmax))



func _physics_process(delta: float) -> void:
	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if isVectorInRange(target_destination, global_position, 0.005):
		target_destination =  get_random_vector()
		
	var next_path_position: Vector3 = target_destination
	var new_velocity: Vector3 = (next_path_position - global_position).normalized() * movement_speed
	velocity = new_velocity
	move_and_slide()








# Find the nearest node in the BIT* tree to a given point
func find_nearest_node(target_point):
	var nearest_node = null
	var nearest_distance = float("inf")
	
	for node in nodes:
		var distance = node.distance_to(target_point)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_node = node
	
	return nearest_node

# Extend the BIT* tree towards a target point
func extend_tree(from_node, target_point):
	# Calculate the direction vector towards the target point
	var direction = (target_point - from_node.position).normalized()
	
	# Calculate the new node position
	var new_node_position = from_node.position + direction * step_size
	
	# Check if the new node collides with any obstacles (you'll need to implement this)
	if !is_collision(new_node_position):
		# Calculate the cost from the parent node to the new node
		var new_node_cost = from_node.cost + step_size
		
		# Find nearby nodes that can potentially be rewired
		var near_nodes = find_nearby_nodes(new_node_position)
		
		var parent_node = null
		var min_cost = new_node_cost
		
		# Iterate through nearby nodes and rewire the tree if a shorter path is found
		for node in near_nodes:
			var potential_cost = node.cost + node.position.distance_to(new_node_position)
			if potential_cost < min_cost:
				parent_node = node
				min_cost = potential_cost
		
		# Update the new node's parent and cost
		var new_node = {curr_position: new_node_position, parent: parent_node, cost: new_node_cost}
		
		# Add the new node to the list of nodes
		nodes.append(new_node)
		
		# Rewire the tree if a shorter path was found
		for node in near_nodes:
			var potential_cost = new_node_cost + new_node.position.distance_to(node.position)
			if potential_cost < node.cost:
				node.parent = new_node
				node.cost = potential_cost
		
		# Draw a line to visualize the new connection
		# draw_line(from_node.position, new_node_position, Color(1, 0, 0), 2)
	
# Function to check if a position is in collision with obstacles (you'll need to implement this)
func is_collision(position):
	# Implement your collision detection logic here
	return false

# Function to find nearby nodes within a certain radius
func find_nearby_nodes(target_point):
	var radius = 5.0
	var near_nodes = []
	
	for node in nodes:
		if node.distance_to(target_point) < radius:
			near_nodes.append(node)
	
	return near_nodes

# Function to find the best path from the goal to the start
func find_best_path():
	for vecs in range(max_iterations):
		# Generate a random point in the 3D space
		var random_point = Vector3(randf() * 20, randf() * 20, randf() * 20)
		
		# Find the nearest node in the BIT* tree to the random point
		var nearest_node = find_nearest_node(random_point)
		
		# Attempt to extend the tree towards the random point
		extend_tree(nearest_node, random_point)
	
	# Find the best path to the goal
	var path = find_best_path()
	# Implement the best path search algorithm (e.g., A* or Dijkstra's) here
	return []





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

