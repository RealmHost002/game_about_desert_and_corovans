extends Position3D




var is_pressable = true
var have_slider = true
var image_path = "res://icon.png"
var type = 'weapon'
var damage_type = 'laser'
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
var distance_tex
var distance = 0.0
var damage_tex
var damage = 0.0
var path_to_fire_anim_node = "res://models/weapons/lasergun/laser_beam.tscn"
var anim_color = Color(1.0, 0,0,1)
var dot_position = Vector3(0, 0.658, 2.391)
var t = 0.0
var m
var direction = Vector3()
var to_target = Vector3()
var rot_speed = 1.0
var energy_cost = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	distance_tex = load("res://models/weapons/lasergun/distance_tex.tres")
	damage_tex = load("res://models/weapons/lasergun/damage_tex.tres")
	step = constants.weapon_check_terrain_step
	mastercar = get_parent().get_parent().get_parent()
	step_time = constants.step_time
	get_node("area").hide()
	camera = get_tree().get_root().get_node('Spatial/camera_look_at/Camera')
	ntex = mastercar.ntex


#	m.set_shader_param('albedo', Color(1 - damage / damage_tex.curve.max_value, 0.9 * damage / damage_tex.curve.max_value,0,0.5))
#	print(self.get_index())
	m = load("res://models/weapons/area_material" + str(self.get_index()) + ".tres")
	var area = load("res://models/weapons/area_mesh" + str(self.get_index()) + ".tres")
#	var s = load("res://models/weapons/area" + str(self.get_index()) + ".shader")
#	m.shader = s
	get_node("area").mesh = area
	get_node("area").mesh.surface_set_material(0, m)
#	print(m)
	death_zone = get_parent().death_zones[self.get_index()]
	print(death_zone)
	m.set_shader_param('death_zone1', death_zone)

#	set_process(false)
#	death_zone = get_parent().death_zones
	pass # Replace with function body.

func fire():
	if !ntex:
		ntex = mastercar.image
	var final_scale = Vector3(0,0,0)
	
	if mastercar.energy < energy_cost / float(burst_size):
		return
	else:
		mastercar.energy -= energy_cost / float(burst_size)
	
	
#	for node in get_parent().get_parent().get_parent().get_parent().get_children():
#		if node != get_parent().get_parent().get_parent():
#			target = node
	var lb = load(path_to_fire_anim_node).instance()
	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(lb)
	lb.global_transform = get_node("dot").global_transform
	lb.look_at(target.global_transform.origin, Vector3(0,1,0))


	var material = lb.get_surface_material(0).duplicate(true)
	material.albedo_color = anim_color
	lb.set_surface_material(0, material)

#	lb.scale.z *= clamp((target.global_transform.origin - self.global_transform.origin).length(), 0, distance)
	lb.scale.x *= 0.1
#	lb.mesh.surface_set_material(0, lb.mesh.surface_get_material(0).duplicate(true))
#	lb.mesh.surface_set_material(0, preload()
#	lb.mesh.surface_get_material(0).albedo_color = Color(0, 1.0, 0, 1)
#	Mesh
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
	
	var dist_to_ray_end = 0
	if c:
		dist_to_ray_end = (s_p - lb.global_transform.origin).length()
	else:
		dist_to_ray_end = clamp((target.global_transform.origin - get_node("dot").global_transform.origin).length(), 0, distance)
#		print('ds',(target.global_transform.origin - self.global_transform.origin).length(),'max', distance, 'scale', lb.scale.z )
#	lb.scale.z *= dist_to_ray_end
	
	var space_state = get_world().direct_space_state
#	if damage_type !=
	var shields_exceptions = []
	for s in get_tree().get_nodes_in_group('shields'):
		if s.get_parent().shield < damage:
			shields_exceptions.append(s)
#			s.hide()

	var result = space_state.intersect_ray(get_node("dot").global_transform.origin, get_node("dot").global_transform.origin + (target.global_transform.origin - get_node("dot").global_transform.origin).normalized() * dist_to_ray_end, [mastercar, get_tree().get_root().get_node('Spatial/camera_look_at/StaticBody')] + shields_exceptions)
	if result:
		print(result['collider'])
		if result['collider'].name == 'shield':
			result['collider'].get_parent().take_damage(damage, damage_type)
		else:
			result['collider'].take_damage(damage, damage_type)
		dist_to_ray_end = (result['position'] - get_node("dot").global_transform.origin).length()
	#IVAN PIDARAS
	lb.scale.z *= dist_to_ray_end




	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
var counter = 0
var some_step = step_time / burst_size * (constants.rng.randf() + 0.5)
func _process(delta):
	if target:
		direction = get_node("dot").global_transform.origin - self.global_transform.origin
		direction.y = 0
		direction = direction.normalized()
		to_target = target.global_transform.origin - get_node("dot").global_transform.origin
		var f = true
		if (self.rotation.y) > self.death_zone.x and (self.rotation.y) < self.death_zone.y:
			if self.rotation.x > -0.3:
				self.rotation.x -= 0.7 * delta
			f = false
		else:
			if self.rotation.x < 0.0:
				self.rotation.x += delta * 0.7
		self.rotate_y(sign(direction.cross(to_target).y) * delta * rot_speed)
	
	
		t += delta
		if t > some_step and direction.angle_to(to_target) < 0.3 and f:
			t = 0
			counter += 1
			fire()
			some_step = step_time / burst_size * (constants.rng.randf() + 0.5)


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
		if result:
			if result['collider'].get_parent() in get_tree().get_nodes_in_group('ally'):
				pass
			else:
				target = result['collider']
#				print(target)
#				print(result)
				unactivate()
#		print(target)
	if event.is_action_pressed("tb2"):
		fire()

func unactivate():
	constants.input_mode = 'car_select'
	get_node("area").hide()
	is_active = false

func slider_changed(value):
	distance = distance_tex.curve.interpolate(value / 100.0)
	damage = damage_tex.curve.interpolate(value / 100.0)
	m.set_shader_param('albedo', Color(1 - damage / damage_tex.curve.max_value, 0.9 * damage / damage_tex.curve.max_value,0,0.5))
	get_node("area").scale = Vector3(distance, distance, distance)



func activate():
	constants.input_mode = 'target_select'
	get_node("area").global_transform.basis = Basis(Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1))
#	get_node("area").get_surface_material(0).set_shader_param("death_zone1", death_zone)
	get_node("area").rotate(Vector3(0, 1, 0), get_node('../../../').rotation.y)
	get_node("area").show()
	get_node("area").scale = Vector3(distance, distance, distance)
	is_active = true
	pass

func _load(params):
	damage_tex = params['damimage']
	distance_tex = params['distimage']
	rot_speed = params['rot_speed']
	get_child(0).mesh = load(params['mesh'])
	path_to_fire_anim_node = params['buletScene']
	anim_color = params['buletColor']
	var v = params['dot_position']
	get_node('dot').transform.origin = Vector3(v[0],v[1],v[2])
	image_path = params['image_path']
	damage_type = params['damage_type']
	burst_size = params['burst_size']
	energy_cost = params['energy_cost']
