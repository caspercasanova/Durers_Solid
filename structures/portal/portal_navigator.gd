extends NavigationLink3D

@onready var portal_navigator: NavigationLink3D = $"."
# make a portal class 
@export var starting_portal: Node3D
@export var ending_portal: Node3D
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	call_deferred("portal_setup")
	pass # Replace with function body.

func portal_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	portal_navigator.start_position = starting_portal.portal_entry.position
	portal_navigator.end_position = ending_portal.portal_entry.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func teleport(body: CharacterBody3D, origin: Vector3):
	if (origin == starting_portal.portal_entry.position):
		print('Transporting body to new location:   ', ending_portal.portal_exit.position)
		body.position = ending_portal.portal_exit.position
	else:
		print('Transporting body to new location:   ', starting_portal.portal_exit.position)
		body.position = starting_portal.portal_exit.position
	

