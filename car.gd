extends  KinematicBody 
#RigidBody
#KinematicBody 
#Spatial


var path = []
var path_visible = true
var energy_drain = 0
var weapon_positions = []
var acc_multiplyer = 2.0
var acc = 0.0
var resistance = 1.0
var is_active = false
var ntex
var noise
var image
var clearance = 0.0
var speed = 0
var forward
var right
var destination = Vector3(20,20,20)
var rotation_speed = 1
var abilities = ['engine']
var sliders = []

#patterns [truck, close_range_combat, mid_range_combat, far_range_combat
#mid_range_support, far_range_support]

#moves [follow, escape, follow_and_attack, escape_and_attack]
var min_range
var is_enemy = true
var combat_bodies = []
var support_bodies = []
var enemy_combats = []
var current_pattern = 'truck'
var current_move = 'escort'
var body_type = 'combat'
var weapon_type = 'close'
var current_target
var target_to_follow
var truck = self


var engine_energy_cost = 20.0
var hp = 100
var max_hp = 100
var shield = 0
var shield_limit = 0
var energy = 100
var energy_production = 0
var max_energy = 0
var wheel_height = 0
#var direction = Vector3()


# Called when the node enters the scene tree for the first time.


func _ready():
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	right = (get_node("dirs/right").global_transform.origin - self.global_transform.origin).normalized() 
	ntex = preload("res://noise.tres")
	yield(ntex, "changed")
	image = ntex.get_data()
	image.save_png("res://noise.png")
	print(image)
#	Image
#	var rsv = ResourceSaver
#	rsv.save("res://noise.png", ntex)
	if image:
		image.lock()
	noise = ntex.noise
	get_node("Sprite3D").material_override = get_node("Sprite3D").material_override.duplicate(true)
#	take_damage(500, "laser")
#	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_enemy:
		do_think(delta)
	if energy < max_energy:
		energy += energy_production * delta / constants.step_time
	else:
		energy = max_energy
	if energy > 0:
		energy -= engine_energy_cost * acc * delta / constants.step_time
	if energy <= 0:
		acc = 0.0
		
	
	if path:
		destination = path[0]
		
		if (Vector3(self.global_transform.origin.x, 0, self.global_transform.origin.z) - Vector3(path[0].x, 0, path[0].z)).length() < 0.1:
			path.pop_front()
	
	if current_move == 'approach' and target_to_follow:
#	 or current_move == 'escort' and target_to_follow:
		destination = target_to_follow.global_transform.origin
		self.acc = clamp((target_to_follow.global_transform.origin - self.global_transform.origin).length() / 2.0 + 1.0 ,0 , 1.0)
	
	elif current_move == 'follow' and target_to_follow:
		destination = target_to_follow.global_transform.origin
		if (target_to_follow.global_transform.origin - self.global_transform.origin).length() < min_range * 0.8:
			self.acc = 0
		else:
			self.acc = 1.0
#		self.acc = clamp((target_to_follow.global_transform.origin - self.global_transform.origin).length() / 2.0 - 0.5 ,0 , 1.0)
	
	
	

	speed += pow(acc, 1) * delta * acc_multiplyer
	speed -= resistance * pow(speed, 2) * delta
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	right = (get_node("dirs/right").global_transform.origin - self.global_transform.origin).normalized() 
	if !is_enemy:
		var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
		var s_buff = sign(forward.cross(destination - self.global_transform.origin).y)
		var f = forward.rotated(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * rotation_speed)
		var after_rot_s_buff = sign(f.cross(destination - self.global_transform.origin).y)
		if s_buff == after_rot_s_buff:
			var r = rotation_speed
			if speed <= 0.5:
				r *= speed
			self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * r)

	var s_height = 0
	if image:
#		var s_height = 0
		for wheel in get_node('wheels').get_children():
			var some_pos = Vector2(wheel.global_transform.origin.x, wheel.global_transform.origin.z) / 20.0 * 1024
			wheel.rotate_x(delta * speed)
			while some_pos.x >= 1024:
				some_pos.x -= 1024
			while some_pos.y >= 1024:
				some_pos.y -= 1024
			wheel.global_transform.origin.y = image.get_pixelv(some_pos).r * 3 + wheel_height / 10.0
			if wheel.name == 'fl' or wheel.name == 'fr' or wheel.name == 'rl' or wheel.name == 'rr':
				s_height += image.get_pixelv(some_pos).r * 3
		s_height = s_height/4.0 + clearance
#		self.global_transform.origin.y = s_height
	var vec1 = get_node("wheels/fr").global_transform.origin - get_node("wheels/rl").global_transform.origin
	var vec2 = get_node("wheels/fl").global_transform.origin - get_node("wheels/rr").global_transform.origin
	get_node("body").rotation = Vector3(0,0,0)
	var vec01 = vec1
	vec01.y = 0
	var vec02 = vec2
	vec01.y = 0
	var a1 = vec01.angle_to(vec1) * sign(vec1.y)
	var a2 = vec02.angle_to(vec2) * sign(vec2.y)
	get_node("body").global_rotate(vec01.cross(Vector3(0, 1, 0)).normalized(), a1)
	get_node("body").global_rotate(vec02.cross(Vector3(0, 1, 0)).normalized(), a2)

	get_node("Sprite3D").material_override.set_shader_param("a", float(hp)/max_hp)


	self.global_transform.origin.y = s_height
	forward.y = 0.0
	move_and_slide(speed * (forward))
#	move_and_collide(speed * (forward) * delta)

#	if Input.is_action_pressed("function_1"):

	
#	if shield < shield_limit:
#		shield += shield_production
#	if energy < max_energy:
#		energy += energy_production * delta / constants.step_time
#	else:
#		energy = max_energy
#	if energy > 0:
#		energy -= engine_energy_cost * acc * delta / constants.step_time
#	if energy <= 0:
#		acc = 0.0
	get_node("Sprite3D").material_override.set_shader_param("b", float(shield)/shield_limit)

func _input(event):
	if event.is_action_pressed('path_visibility'):
		if path_visible:
			hide_path()
			path_visible = false
		else:
			show_path()
			path_visible = true
	if self != constants.selectedCar:
		return
	if event.is_action_pressed('attack'):
		self.attack_with_all_weapons()
	if event.is_action_pressed('active_1'):
		var w = get_node("body/weapons").get_child(0)
		if w.is_pressable:
			w.activate()
	if event.is_action_pressed('active_2'):
		var w = get_node("body/weapons").get_child(1)
		if w.is_pressable:
			print('some')
			w.activate()
	if event.is_action_pressed('active_3'):
		var w = get_node("body/weapons").get_child(2)
		if w.is_pressable:
			w.activate()
		pass


func do_think(d):
	var distance_to_dest = (destination - self.global_transform.origin).length()
	var dest_behind = sign((destination - self.global_transform.origin).cross(right).y)
#	enemy_combats = []
#	for enemy
#	self.speed > truck.speed
	var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
	var s_buff = sign(forward.cross(destination - self.global_transform.origin).y)
	var f = forward.rotated(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * d * rotation_speed)
	var after_rot_s_buff = sign(f.cross(destination - self.global_transform.origin).y)
	var r = 0
	if s_buff == after_rot_s_buff:
		r = rotation_speed
		var close_combat_enemies_position = Vector3(0,0,0)
	
	
	
	var close_combat_count = 0.0
	var close_combat_enemies_position = Vector3(0,0,0)
	enemy_combats = []
	for enemy in get_tree().get_nodes_in_group('ally'):
#		if enemy.current_pattern[0] == 'combat' and enemy.current_pattern[1] != 'far':
		close_combat_count += 1
		close_combat_enemies_position += enemy.global_transform.origin
		enemy_combats.append(enemy)
	close_combat_enemies_position /= enemy_combats.size()
	

	
	
	if self.current_move == 'escort':
		if dest_behind > 0:
			self.acc = 0.0
#			r *= 0.1
		else:
			self.acc = clamp(distance_to_dest / 2.0, 0, 1.0)
	


	if self.current_pattern[0] == 'truck':
		self.current_move = 'escape'
		for ally in get_tree().get_nodes_in_group('enemy'):
			ally.truck = self
		destination = Vector3(100, 0, 100)
	else:
		var enemy_to_block = enemy_combats[self.get_index() - 4]
		
		var to_truck = truck.global_transform.origin - enemy_to_block.global_transform.origin
		self.destination = truck.global_transform.origin - to_truck.normalized() * 3 + (to_truck).cross(Vector3(0, 1,0)).normalized() * (self.get_index() - 6) * 0
		for w in get_node("body/weapons").get_children():
			if w.type == 'weapon':
				if w.distance_tex.curve.max_value > (enemy_to_block.global_transform.origin - self.global_transform.origin).length():
					w.slider_changed(100.0)
					w.target = enemy_to_block
				else:
					w.slider_changed(1.0)
					w.target = 0
					for enemy in get_tree().get_nodes_in_group('ally'):
						if w.distance_tex.curve.max_value > (enemy.global_transform.origin - self.global_transform.origin).length():
							w.slider_changed(100.0)
							w.target = enemy
	if speed <= 0.5:
		r *= speed
	self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * d * r)

	
	
#func closest_enemy():
	
		














func destroy():
	self.queue_free()
	pass
	
func take_damage(damage, weaponType, status = "no"):
	hp -= damage
	if hp <= 0:
		destroy()
	if status != 'no':
		pass

func attack_with_all_weapons(target = 0):
	if target:
		for w in get_node("body/weapons").get_children():
			if w.type == 'weapon':
				w.target = target
	else:
		for w in get_node("body/weapons").get_children():
			if w.type == 'weapon':
				w.activate()




func ability_used(id):
	if abilities[id] == 'weap':
		var w = get_node("body/weapons").get_child(id)
		w.activate()
	if abilities[id] == 'engine':
		pass


func slider_changed(id, value):
	constants.sliders[name][id] = value

	if abilities[id] == 'engine':
		sliders[id] = value / 100.0
		acc = value / 100.0
		show_path()
	elif abilities[id] == 'weap' or 'shield':
		var w = get_node("body/weapons").get_child(id)
		w.slider_changed(value)
		sliders[id] = value / 100.0
	calc_en_drain()

func pause():
	self.set_process(false)
	for w in get_node("body/weapons").get_children():
		w.set_process(false)
	show_path()

func unpause():
	self.set_process(true)
	self.shield = 0
#	self.acc = sliders[0]
	for w in get_node("body/weapons").get_children():
		if w.type == 'weapon':
			if w.target:
				w.set_process(true)
		elif w.type == 'shield':
			w.enable_shield()

#			self.shield += w.current_sh_gen
#				self.energy -= w.current_en_cost

		elif w.type == 'generator':
#			self.energy_production += w.energy_production
			pass
	if self.shield:
		get_node("body/weapons").get_child(sliders.size()-1).show()
	hide_path()
	
	
func hide_path():
	for child in get_node("Mypath").get_children():
		child.queue_free()
	pass


func show_path():
	hide_path()
	var spd = speed
	var f = forward
	var p = self.global_transform.origin
	var pa
	if path:
		pa = path.duplicate()
	else:
		pa = [destination]
	
	p.y = 2
	var c = 0
	while (p - pa[-1]).length() > 0.1:
		spd += pow(acc, 1) * acc_multiplyer * 0.1
		spd -= resistance * pow(spd, 2) * 0.1
		
		var m = MeshInstance.new()

		if c < 10 * constants.step_time:
			m.mesh = load("res://new_cubemesh_green.tres")
		else:
			m.mesh = load("res://new_cubemesh.tres")
		get_node("Mypath").add_child(m)
		m.global_transform.origin = p
#		if image:
#			var some_pos = Vector2(m.global_transform.origin.x, m.global_transform.origin.z) / 20.0 * 1024
#			m.global_transform.origin.y = image.get_pixelv(some_pos).r * 3
		f = f.rotated(Vector3(0,1,0), sign(f.cross(pa[0] - p).y) * 0.1 * rotation_speed)
		p += f * 0.1 * spd
		c += 1
		if (p - pa[0]).length() < 0.1:
			pa.pop_front()
			if !pa:
				break
		if c > 100:
			break
		pass
	pass




func _on_input_event(camera, event, click_position, click_normal, shape_idx, from_gui = 0):
	if self in get_tree().get_nodes_in_group('ally'):
		if constants.input_mode != 'car_select':
			return
		if from_gui:
			constants.selectedCar = self
			for car in get_tree().get_nodes_in_group('ally'):
				car.hide_enemies()
			show_enemies()
		elif event.is_action('left_click'):
			constants.selectedCar = self
			get_node("../../GUI/HBoxContainer").get_child(self.get_index())._on_TextureButton_pressed()
			for car in get_tree().get_nodes_in_group('ally'):
				car.hide_enemies()
			show_enemies()

		
	if !from_gui:
		if event.is_action('right_click') and constants.selectedCar:
			var radial_menu = load("res://gui/radial_menu.tscn").instance()
			get_parent().get_parent().get_node('GUI').add_child(radial_menu)
			radial_menu.rect_position = event.position
			radial_menu.choosen_car = self

func _load(params):
	get_node("body").mesh = load(params['body'])
	var wp = params['wheel_pos']
	get_node("wheels/fl").mesh = load(params['wheelFront'])
	get_node("wheels/fl").transform.origin = Vector3(wp[0], 0, wp[1])
	get_node("wheels/fr").mesh = load(params['wheelFront'])
	get_node("wheels/fr").transform.origin = Vector3(-wp[0], 0, wp[1])
	get_node("wheels/rl").mesh = load(params['wheelBack'])
	get_node("wheels/rl").transform.origin = Vector3(wp[2], 0, wp[3])
	get_node("wheels/rr").mesh = load(params['wheelBack'])
	get_node("wheels/rr").transform.origin = Vector3(-wp[2], 0, wp[3])
	if wp[4] == 0:
		get_node("wheels/ml").hide()
		get_node("wheels/mr").hide()
	get_node("wheels/ml").mesh = load(params['wheelBack'])
	get_node("wheels/ml").transform.origin = Vector3(wp[4], 0, wp[5])
	get_node("wheels/mr").mesh = load(params['wheelBack'])
	get_node("wheels/mr").transform.origin = Vector3(-wp[4], 0, wp[5])
	
	
	self.wheel_height = params['wheel_height']
	self.engine_energy_cost = params['engine_cost']
	self.hp = params['hp']
#	max_hp 
	self.max_hp  = params['hp']
	self.resistance = float(params['resistance'])
	self.rotation_speed = float(params['rot_speed'])
	self.acc_multiplyer = float(params['acc_multiplyer'])
	var v = params['weapon_positions']
	for i in range(v.size() / 3):
		i *= 3
		self.weapon_positions.append(Vector3(v[i], v[i+1], v[i+2]))
#	self.weapon_positions = [Vector3(v[0], v[1], v[2]),Vector3( v[3], v[4], v[5])]
	get_node("CollisionShape").shape = load(params['col_shape'])
	v = params['col_shape_pos']
	get_node("CollisionShape").transform.origin = Vector3(v[0], v[1], v[2])
	v = params['death_zones']
	get_node("body/weapons").death_zones = [0, Vector2(v[0], v[1]), Vector2(v[2], v[3])]
	
	body_type = params['type']
#	if params['type'] in combat_bodies:
#		body_type = 'combat'
#	elif params['type'] in support_bodies:
#		body_type = 'support'
#	else:
#		body_type = 'truck'
	
func load_modules(params):
	var modules_node = get_node("body/weapons")
	var engine = load("res://models/engine.tscn").instance()
	modules_node.add_child(engine)
	engine.energy_cost = self.engine_energy_cost
	var c = 0
	for w in params['weapons']:
		if w:
			var weap = load("res://models/weapons/weapon.tscn").instance()
			modules_node.add_child(weap)
			weap.transform.origin = weapon_positions[c]
			c += 1
			weap._load(Saveload.weapon_data[w])
			abilities.append('weap')
			weap._name = str(w)
	for g in params['generator']:
		if g:
			var gen = load("res://models/generator.tscn").instance()
			modules_node.add_child(gen)

			gen._load(Saveload.generators_data[g])
			abilities.append('generator')

	for s in params['shields']:
		if s:
			var sh = load("res://models/shield.tscn").instance()
			modules_node.add_child(sh)
			sh._load(Saveload.shields_data[s])
			abilities.append('shield')
			shield_limit += sh.max_value

	for i in abilities.size():
		sliders.append(0)
	constants.sliders[name] = self.sliders


	var ranges = []
	for m in modules_node.get_children():
		if m.type == 'weapon':
			ranges.append(m.distance_tex.curve.max_value)
	min_range = ranges.min()
	if min_range < 6.0:
		weapon_type = 'close'
	elif min_range < 12:
		weapon_type = 'mid'
	else:
		weapon_type = 'far'
	
	current_pattern = [body_type, weapon_type]
	
func calc_en_drain():
	energy_drain = 0
	var c = 0
	for module in get_node("body/weapons").get_children():
		energy_drain += sliders[c] * module.energy_cost
		c += 1
	pass

func show_enemies():
	for w in get_node("body/weapons").get_children():
		if w.type == 'weapon':
			if w.target:
				w.target.get_node('target_obj').show()
				var s = w.target.get_node('CollisionShape').shape.radius + w.target.get_node('CollisionShape').shape.height
				w.target.get_node('target_obj').scale = Vector3(s, s, s)
				w.target.get_node('target_obj').set_surface_material(0, load("res://gui/target_material_car.tres"))

func hide_enemies():
	for w in get_node("body/weapons").get_children():
		if w.type == 'weapon':
			if w.target:
				w.target.get_node('target_obj').hide()
#				var s = w.target.get_node('CollisionShape').shape.radius + w.target.get_node('CollisionShape').shape.height
#				w.target.get_node('target_obj').scale = Vector3(s, s, s)
#				w.target.get_node('target_obj').set_surface_material(0, load("res://gui/target_material_car.tres"))

	
	
	pass
