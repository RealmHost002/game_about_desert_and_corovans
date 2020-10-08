extends Camera


var drag = 0
var anti_speed = 20.0
var drag_horizontal = 0.0
var drag_vertical = 0.0

var drag_speed = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion and drag:
		get_parent().global_transform.origin += (get_node("../x").global_transform.origin - get_parent().global_transform.origin) * event.relative.x / anti_speed + (get_node("../z").global_transform.origin - get_parent().global_transform.origin) * event.relative.y / anti_speed
	
	var close_up_vec = (self.global_transform.origin - get_parent().global_transform.origin).normalized()
	if event.is_action_pressed('wheel_up'):
#		self.fov -= 7.0
		self.global_transform.origin -= close_up_vec
	if event.is_action_pressed('wheel_down'):
#		self.fov += 7.0
		self.global_transform.origin += close_up_vec
	if event is InputEventMouseMotion:
#		print(event.position.y)
		if event.position.x == constants.machine_resolution.x - 1:
			drag_horizontal = 1.0
		elif event.position.x == 0:
			drag_horizontal = -1.0
		else:
			drag_horizontal = 0.0
		if event.position.y == constants.machine_resolution.y - 1:
			drag_vertical = 1.0
		elif event.position.y == 0:
			drag_vertical = -1.0
		else:
			drag_vertical = 0.0
	if event.is_action_pressed("ui_down"):
		drag_vertical = 1
	if event.is_action_pressed("ui_up"):
		drag_vertical = -1
	if event.is_action_pressed("ui_right"):
		drag_horizontal = 1
	if event.is_action_pressed("ui_left"):
		drag_horizontal = -1
	if event.is_action_released("ui_down") or event.is_action_released("ui_up"):
		drag_vertical = 0
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		drag_horizontal = 0
			
			
			
			
			
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
	
	get_parent().global_transform.origin.x += delta * drag_horizontal * drag_speed
	get_parent().global_transform.origin.z += delta * drag_vertical * drag_speed
	
	
	
	
