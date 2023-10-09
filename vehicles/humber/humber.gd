extends VehicleBody3D
# https://github.com/KenneyNL/Starter-Kit-3D-Platformer/blob/main/scripts/player.gd
# vehicle variables
var horsepower = 500
var acceleration_speed = 100
var steer_angle = deg_to_rad(30)
var steer_speed = 3
var brake_power = 40
var brake_speed = 40

# weapon variables  
var max_turrent_x = deg_to_rad(30)
var min_turrent_x = deg_to_rad(-10)
@onready var muzzle = $turrent/gun/gun_muzzle
# @onready var rocket_scene = preload("res://scenes/rocket.tscn") # because the rocket isnt apart of the scene, preload it so it laods
var fire_rate = 1
var can_fire = true

# navigation
# @onready var navigation_agent: NavigationAgent3D = ool
var is_NPC_controlled = true 

var movement_target_position: Vector3 = Vector3(-3.0,0.0,2.0)
var points_to_visit = [Vector3(-10,0,0), Vector3(-5, 0,-5), Vector3(13, 0,13), Vector3(0, 0, 0)]

var target = Vector3.ZERO
var path = []



func _ready(): 
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	# navigation_agent.path_desired_distance = 0.5
	# navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	# call_deferred("actor_setup")
	pass

func _process(_delta):
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# throttle
	var throttle_input = Input.get_axis("W", "S") 
	engine_force = lerp(engine_force, throttle_input * horsepower, acceleration_speed * delta) 
	
	# steering
	var steer_input = Input.get_axis("D", "A") 
	steering = lerp(steering, steer_input * steer_angle, steer_speed * delta)
	
	# braking
	var brake_input = Input.get_action_strength("SPACE")
	brake = lerp(brake, brake_input * brake_power, brake_speed * delta)
	
	# TODO: Solve AI Pathing of a kinematic body
	


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	if Input.is_action_pressed("RMB"): 
		$turrent.rotation.y = lerp_angle($turrent.rotation.y, $humber_camera_spring.rotation.y, 0.02)
		$turrent/gun.rotation.x = lerp_angle($turrent/gun.rotation.x, $humber_camera_spring.rotation.x, 0.02)
		$turrent/gun.rotation.x = clamp($turrent/gun.rotation.x,  min_turrent_x, max_turrent_x )
		$humber_camera_spring.spring_length = lerp($humber_camera_spring.spring_length, 3.0, 0.1)
		
		# Shoot 
		if Input.is_action_just_pressed("LMB"):
			if can_fire:
				# var rocket = rocket_scene.instantiate()
				# muzzle.add_child(rocket)
				# rocket.set_as_top_level(true)
				# can_fire = false
				# await get_tree().create_timer(fire_rate).timeout # dont know if i like this.
				# can_fire = true
				print('Firing, but un comment this code')
	else:
		$humber_camera_spring.spring_length = lerp($humber_camera_spring.spring_length, 5.0, 0.1)	
		


func calculate_path():
	#var begin = navigation_agent.get_closest_point(global_transform.origin)
	#var end = navigation_agent.get_closest_point(target)
	#path = navigation_agent.get_simple_path(begin, end, true) 
	#path.invert()
	#set_process(true)
	pass


func handle_fire():
	pass


func actor_setup():
	movement_target_position = Vector3(-3.0,0.0,2.0) 

	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(_movement_target: Vector3):
	# navigation_agent.set_target_position(movement_target)
	pass 








