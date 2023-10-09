extends ImmediateMesh
##
#extends Node3D


func create_line(points: Array[Vector3]):
	if(points.size() >= 1 ):
		return

	# Clean up before drawing.
	clear_surfaces()
	# Begin draw.
	surface_begin(Mesh.PRIMITIVE_TRIANGLES)

	for p in points:
		surface_add_vertex(p)

	surface_end()

	pass


func draw_sphere(target_location: Vector3) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.transform.origin = target_location
	var mesh = SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 0.5 * 2
	mesh_instance.mesh = mesh
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.6878816485405, 0.1529648900032, 0)
	mesh_instance.material_override = material
	return mesh_instance
