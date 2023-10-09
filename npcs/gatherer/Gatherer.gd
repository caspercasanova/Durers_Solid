class_name Gatherer extends Dummy

@export_category('Gatherer')


func _ready() -> void:
	pass

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	navigation_is_synced = true
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	


func _physics_process(_delta):
	# can eventually add the -y when flying 
	# plus parachute action
	return
