extends StaticBody3D



@export var portal_navigator: NavigationLink3D = null
@onready var portal_entry: Area3D = %portal_entry
@onready var portal_exit: Marker3D= %portal_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# https://godotassetlibrary.com/asset/DOBVVd/advanced-movement-system-godot-(amsg)-template
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_portal_entry_body_entered(body: Node3D) -> void:
	portal_navigator.teleport(body, portal_entry.position)
	pass # Replace with function body.


func _on_portal_entry_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
