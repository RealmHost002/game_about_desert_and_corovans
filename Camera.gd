extends Camera


var drag = 0
var anti_speed = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion and drag:
		get_parent().global_transform.origin += (get_node("../x").global_transform.origin - get_parent().global_transform.origin) * event.relative.x / anti_speed + (get_node("../z").global_transform.origin - get_parent().global_transform.origin) * event.relative.y / anti_speed
	if event.is_action_pressed('wheel_up'):
		self.fov -= 7.0
	if event.is_action_pressed('wheel_down'):
		self.fov += 7.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('drag_camera'):
		drag = 1
	else:
		 drag = 0
	var pos_vec = get_parent().global_transform.origin - Vector3(10, 0, 10)
	pos_vec.y = pos_vec.z
	pos_vec.z = 0
	get_node("../MeshInstance").get_surface_material(0).set_shader_param("uv1_offset", pos_vec / 20.0)
