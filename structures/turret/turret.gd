class_name Turret extends RigidBody3D


################################
# EXPORT PARAMS
################################
@onready var body: CollisionShape3D = %body
@onready var head: CollisionShape3D = %head
@onready var gun: MeshInstance3D = %Gun
@onready var target: Node3D = %target_path
@onready var area_of_operation: Area3D = %area_of_operation
@onready var laser: RayCast3D = %laser

# make this so we can set the radius automatically 
@export var area_of_operation_radius = 1
# movement
@export var elevation_speed_deg: float = 45
@export var rotation_speed_deg: float = 90
# bullets
@export var muzzle_velocity: float = 50
# constraints
@export var min_elevation: float = -10
@export var max_elevation: float = 60
@onready var elevation_speed: float = deg_to_rad(elevation_speed_deg)
@onready var rotation_speed: float = deg_to_rad(rotation_speed_deg)

# target calculation
var ttc: float
@export var current_target: Vector3
var current_aim: Vector3
# states
enum states {active, patrol, sleep}
var current_state:states

var turret_health = 100
var turret_head_health = 50
var turret_gun_health = 40
var turret_rotor_health = 40
var turret_eye_health = 15

enum turret_locations { turret_health ,turret_head_health ,turret_gun_health ,turret_rotor_health ,turret_eye_health}

var should_explode = false
var current_weapon = null

var current_targets = {}

################################
# OVERRIDE FUNCTIONS
################################
func _ready() -> void:
	if target == null or not "linear_velocity" in target:
		current_state = states.sleep


func _process(delta: float) -> void:
	# if not active do nothing
	if current_state == states.sleep:
		return
	# update target location
	_update_target_location()
	# move
	_rotate(delta)
	_elevate(delta)


################################
# MAIN FUNCTIONS
################################
## convert turrets possible to switch groups 
func _on_area_of_operation_body_entered(body: Node3D) -> void:
	if body.is_in_group("humanoid"):
		print('Added a body to the weapons array')
		current_targets[body.get_instance_id()] = true
		print(current_targets)
	pass # Replace with function body.


func _on_area_of_operation_body_exited(body: Node3D) -> void:
	if body.is_in_group("humanoid") && current_targets.has(body.get_instance_id()):
		print('Erasing a weapon in the area')
		current_targets.erase(body.get_instance_id())
		print(current_targets)
	pass # Replace with function body.


func is_target_visible(target: Node3D, visible_range: int = 20):
	var direction = (target.global_position - laser.global_position).normalized()
	
	laser.cast_to = direction * visible_range 
	laser.force_raycast_update()
	
	
	if laser.is_colliding():
		return laser.get_colliding() == target
	
	return false 






func _update_target_location() -> void:
	current_target = target.global_transform.origin


func _rotate(delta: float) -> void:
	# get displacment
	var y_target = _get_local_y()
	# calculate step size and direction
	var final_y = sign(y_target) * min(rotation_speed * delta, abs(y_target))
	# rotate body
	head.rotate_y(final_y)


func _elevate(delta: float) -> void:
	# get displacment
	var x_target = _get_global_x()
	var x_diff = x_target - gun.global_transform.basis.get_euler().x
	var final_x = sign(x_diff) * min(elevation_speed * delta, abs(x_diff))
	# elevate head
	gun.rotate_x(final_x)
	# clamp
	gun.rotation_degrees.x = clamp(
		gun.rotation_degrees.x,
		min_elevation, max_elevation
	)




################################
# HELPER FUNCTIONS
################################
func _get_ttc() -> float:
	# calculate everything once
	var to_target = target.global_transform.origin - gun.global_transform.origin
	var target_velocity = target.linear_velocity
	# transform to quadratic
	var a = target_velocity.dot(target_velocity) - muzzle_velocity * muzzle_velocity
	var b = 2 * target_velocity.dot(to_target)
	var c = to_target.dot(to_target)
	
	# don't divide by zero
	if a == 0:
		return 0.0
	# don't take sqrt of negative number
	var d = b * b - 4 * a * c
	if d < 0:
		return 0.0
	
	var p = -b / (2 * a)
	var q = sqrt(d) / (2 * a)
	# solve
	var t1 = p - q
	var t2 = p + q
	# choose and return solution
	var t = 0
	if t1 > t2 and t2 > 0:
		t = t1
	else:
		t = t2
	# make sure t is possitive
	return max(0.0, t)


func _get_ttc2() -> float:
	# calculate constants once
	var to_target = target.global_transform.origin - gun.global_transform.origin
	var target_velocity = target.linear_velocity
	var a = target_velocity.dot(target_velocity) - muzzle_velocity * muzzle_velocity
	var b = 2 * target_velocity.dot(to_target)
	var c = to_target.dot(to_target)

	# don't divide by zero
	if a == 0:
		return 0.0

	# calculate discriminant once
	var d = b * b - 4 * a * c

	# don't take sqrt of negative number
	if d < 0:
		return 0.0

	# calculate t values
	var p = -b / (2 * a)
	var q = sqrt(d) / (2 * a)

	# calculate both solutions
	var t1 = p - q
	var t2 = p + q

	# choose and return solution
	var t = min(t1, t2) if t1 > 0 else t2

	# make sure t is positive
	return max(0.0, t)




func _get_local_y() -> float:
	print(gun)
	print(current_target)
	var local_target = gun.to_local(current_target)
	var y_angle = Vector3.FORWARD.angle_to(local_target * Vector3(1, 0, 1))
	return y_angle * -sign(local_target.x)


func _get_global_x() -> float:
	var local_target = current_target - gun.global_transform.origin
	return (local_target * Vector3(1, 0, 1)).angle_to(local_target) * sign(local_target.y)






