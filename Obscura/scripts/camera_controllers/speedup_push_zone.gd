class_name SpeedupPushZone
extends CameraControllerBase

# push_ratio is a ratio of the target velocity and is limited to 1
@export_range(0, 1, 0.05) var push_ratio:float = 0.75
@export var pushbox_top_left := Vector2(-5, -5)
@export var pushbox_bottom_right := Vector2(5, 5)
@export var speedup_zone_top_left := Vector2(-4, -4)
@export var speedup_zone_bottom_right := Vector2(4, 4)


func _ready() -> void:
	super()
	position = target.position
	draw_camera_logic = true


func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		# drawing speedup zone box in grey
		_draw_speedup()
		
	super(delta)


func _physics_process(delta: float) -> void:
	var tpos = target.global_position
	var cpos = global_position
	var box_width = abs(pushbox_bottom_right.x - pushbox_top_left.x)
	var box_height = abs(pushbox_bottom_right.y - pushbox_top_left.y)
	var speedup_zone_width = abs(speedup_zone_bottom_right.x - speedup_zone_top_left.x)
	var speedup_zone_height = abs(speedup_zone_bottom_right.y - speedup_zone_top_left.y)
	
	# speedbox checks
	var diff_between_speedup_left = (tpos.x - target.WIDTH / 2.0) - (cpos.x - speedup_zone_width / 2.0)
	var diff_between_speedup_right = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedup_zone_width / 2.0)
	var diff_between_speedup_top = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - speedup_zone_height / 2.0)
	var diff_between_speedup_bottom = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedup_zone_height / 2.0)
	var in_speedbox_zone = diff_between_speedup_left < 0 or diff_between_speedup_right > 0 or diff_between_speedup_top < 0 or diff_between_speedup_bottom > 0 

	# boundary checks
	# left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if in_speedbox_zone and target.velocity.x < 0 and diff_between_left_edges > 0:
		global_position.x += target.velocity.x * push_ratio * delta
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges

	# right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if in_speedbox_zone and target.velocity.x > 0 and diff_between_right_edges < 0:
		global_position.x += target.velocity.x * push_ratio * delta
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges

	# top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if in_speedbox_zone and target.velocity.z < 0 and diff_between_top_edges > 0:
		global_position.z += target.velocity.z * push_ratio * delta
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges

	# bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if in_speedbox_zone and target.velocity.z > 0 and diff_between_bottom_edges < 0:
		global_position.z += target.velocity.z * push_ratio * delta
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var box_width = abs(pushbox_bottom_right.x - pushbox_top_left.x)
	var box_height = abs(pushbox_bottom_right.y - pushbox_top_left.y)
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()


func _draw_speedup() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var speedup_zone_width = abs(speedup_zone_bottom_right.x - speedup_zone_top_left.x)
	var speedup_zone_height = abs(speedup_zone_bottom_right.y - speedup_zone_top_left.y)
	var left:float = -speedup_zone_width / 2
	var right:float = speedup_zone_width / 2
	var top:float = -speedup_zone_height / 2
	var bottom:float = speedup_zone_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.GRAY
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	# mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
