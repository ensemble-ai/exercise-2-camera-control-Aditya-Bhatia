class_name PositionLockLerp
extends CameraControllerBase

#follow_speed is a ratio of the target's velocity
#catchup_speed is also a multiplier that has min 0 and max 1
@export_range(0, 1, 0.05) var follow_speed:float = 0.75
@export_range(0, 1, 0.05) var catchup_speed:float = 0.5
@export var leash_distance:float = 5

func _ready():
	super()
	draw_camera_logic = true
	position = target.position


func _process(delta: float) -> void:
	if !current:
		return

	if draw_camera_logic:
		draw_logic()

	super(delta)


func _physics_process(delta: float) -> void:
	if target.velocity == Vector3(0, 0, 0) and position != target.position:
		var cpos = position
		position = cpos.lerp(target.position, 0.15 * catchup_speed)
	
	var cpos_xz = Vector2(position.x, position.z)
	var tpos_xz = Vector2(target.position.x, target.position.z)
	if cpos_xz.distance_to(tpos_xz) > leash_distance:
		position += target.velocity * delta
	else:
		position += target.velocity * follow_speed * delta


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	var height:float = 5
	var width:float = 5

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(-width/2, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(width/2, 0, 0))

	immediate_mesh.surface_add_vertex(Vector3(0, 0, -height/2))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, height/2))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
