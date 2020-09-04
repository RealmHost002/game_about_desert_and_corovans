extends Position3D


var type = 'weapon'
var energy = 100
var step = 0.1
var mastercar
var ntex
var burst_size = 6.0
var step_time = 1.0
var death_zone = Vector2()
var is_active = false
var camera
var target = 0
var distance = 3.0
var path_to_fire_anim_node = "res://trash textures/laser_beam.tscn"
var t = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	step = constants.weapon_check_terrain_step
	mastercar = get_parent().get_parent().get_parent()
	step_time = constants.step_time
	get_node("area").hide()
	camera = get_tree().get_root().get_node('Spatial/camera_look_at/Camera')
	ntex = mastercar.ntex
#	print(ntex)
#	set_process(false)
#	death_zone = get_parent().death_zones
	pass # Replace with function body.

func fire():
	if !ntex:
		ntex = mastercar.image
	var final_scale = Vector3(0,0,0)

#	for node in get_parent().get_parent().get_parent().get_parent().get_children():
#		if node != get_parent().get_parent().get_parent():
#			target = node
	var lb = load(path_to_fire_anim_node).instance()
	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(lb)
	lb.global_transform = self.global_transform
	lb.look_at(target.global_transform.origin, Vector3(0,1,0))
	lb.set_surface_material(0, lb.get_surface_material(0).duplicate(true))
#	lb.scale.z *= clamp((target.global_transform.origin - self.global_transform.origin).length(), 0, distance)
	lb.scale.x *= 0.1
	
	var s_p = lb.global_transform.origin
	var c = 1.0 / step
	while c:
		
		var some_pos = Vector2(s_p.x, s_p.z) / 20.0 * 1024
		while some_pos.x >= 1024:
			some_pos.x -= 1024
		while some_pos.y >= 1024:
			some_pos.y -= 1024
			
		
		s_p += (target.global_transform.origin - lb.global_transform.origin) * step * 0.1
		if (s_p - lb.global_transform.origin).length() > (target.global_transform.origin - lb.global_transform.origin).length():
			break
		
		
		if s_p.y < ntex.get_pixelv(some_pos).r * 3:
			break
		c -= 1
	if c:
		lb.scale.z *= (s_p - lb.global_transform.origin).length()
	else:
		lb.scale.z *= clamp((target.global_transform.origin - self.global_transform.origin).length(), 0, distance)
#		print('ds',(target.global_transform.origin - self.global_transform.origin).length(),'max', distance, 'scale', lb.scale.z )

	#IVAN PIDARAS

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var counter = 0
var some_step = step_time / burst_size * (constants.rng.randf() + 0.5)
func _process(delta):
	t += delta
	if t > some_step:
		t = 0
		counter += 1
		fire()
		some_step = step_time / burst_size * (constants.rng.randf() + 0.5)
#		print(counter)


func _input(event):
	if event.is_action_pressed("drag_camera") and is_active:
		unactivate()
		target = 0


	var ray_length = 100
	
	if is_active and event.is_action_pressed("left_click"):
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from, to, [self, get_tree().get_root().get_node('Spatial/camera_look_at/StaticBody')])
		print(result)
		if result:
			if result['collider'].get_parent() in get_tree().get_nodes_in_group('ally'):
				pass
			else:
				target = result['collider'].get_parent()
				print(target.get_child(4))
				unactivate()
	if event.is_action_pressed("tb2"):
		fire()

func unactivate():
	constants.input_mode = 'car_select'
	get_node("area").hide()
	is_active = false

func activate():
	constants.input_mode = 'target_select'
	get_node("area").global_transform.basis = Basis(Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1))
#	get_node("area").get_surface_material(0).set_shader_param("death_zone1", death_zone)
	get_node("area").show()
	get_node("area").scale = Vector3(distance, distance, distance)
	is_active = true
	pass
