extends  KinematicBody 
#RigidBody
#KinematicBody 
#Spatial

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

var current_pattern = 'truck'


var hp = 100
var max_hp = 100
var shield = 0
var shield_limit = 50
var energy = 100
var energy_production = 0
var max_energy = 100
#var direction = Vector3()


# Called when the node enters the scene tree for the first time.


func _ready():
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	ntex = preload("res://noise.tres")
	yield(ntex, "changed")
	image = ntex.get_data()
	if image:
		image.lock()
	noise = ntex.noise
	get_node("Sprite3D").material_override = get_node("Sprite3D").material_override.duplicate(true)
#	take_damage(500, "laser")
#	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed += acc * acc * delta
	speed -= resistance * speed * speed * delta
	forward = (get_node("dirs/forward").global_transform.origin - self.global_transform.origin).normalized()
	var angle_to_destination = forward.angle_to(destination - self.global_transform.origin)
	self.rotate(Vector3(0,1,0), sign(forward.cross(destination - self.global_transform.origin).y) * delta * clamp(angle_to_destination, 0.5, 1) * rotation_speed)
#	self.global_transform.origin += forward * delta * speed
	var s_height = 0
	if image:
#		var s_height = 0
		for wheel in get_node('wheels').get_children():
			var some_pos = Vector2(wheel.global_transform.origin.x, wheel.global_transform.origin.z) / 20.0 * 1024
			while some_pos.x >= 1024:
				some_pos.x -= 1024
			while some_pos.y >= 1024:
				some_pos.y -= 1024
			wheel.global_transform.origin.y = image.get_pixelv(some_pos).r * 3
			s_height += wheel.global_transform.origin.y
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


	
#	if shield < shield_limit:
#		shield += shield_production
	if energy < max_energy:
		energy += energy_production * delta
	else:
		energy = max_energy
	if energy > 0:
		energy -= 20 * acc * delta / acc_multiplyer
	if energy <= 0:
		acc = 0.0
	

	
func destroy():
	self.queue_free()
	pass
	
func take_damage(damage, weaponType, status = "no"):
	if weaponType == "laser":
		if shield > 0:
			if damage <= shield:
				shield -= damage
				get_node("Sprite3D").material_override.set_shader_param("b", float(shield)/shield_limit)
			else:
				damage -= shield
				shield = 0
				get_node("Sprite3D").material_override.set_shader_param("b", 0)
				hp -= damage
				get_node("body/weapons").get_child(sliders.size() - 1).hide()

		else:
			hp -= damage
#			get_node("Sprite3D").material_override.set_shader_param("a", float(hp)/max_hp)
			if hp <=0:
					self.destroy()
#		get_node("Sprite3D").material_override.set_shader_param("a", float(hp)/max_hp)
	else:
		hp -= damage
	if status != 'no':
		pass

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
		acc = value / 100.0 * acc_multiplyer
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
			if energy - w.current_en_cost >= 0:
				self.shield += w.current_sh_gen
				self.energy -= w.current_en_cost

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
	p.y = 2
	var c = 0
	while (p - destination).length() > 0.1:
		spd += acc * 0.1
		spd -= resistance * spd * spd * 0.1
		
		var m = MeshInstance.new()
		if c < 10 * constants.step_time:
			m.mesh = load("res://new_cubemesh_green.tres")
		else:
			m.mesh = load("res://new_cubemesh.tres")
		get_node("Mypath").add_child(m)
		m.global_transform.origin = p
		f = f.rotated(Vector3(0,1,0), sign(f.cross(destination - p).y) * 0.1 * rotation_speed)
		p += f * 0.1 * spd
		c += 1
		if c > 100:
			break
		pass
	pass




func _on_input_event(camera, event, click_position, click_normal, shape_idx, from_gui = 0):
	if !(self in get_tree().get_nodes_in_group('ally')):
		return
	if constants.input_mode != 'car_select':
		return
#	get_node("../../GUI/HBoxContainer").get_child(self.get_index())._on_TextureButton_pressed()

	if from_gui:
		constants.selectedCar = self
#		is_active = true
#		for node in get_parent().get_children():
#			if node != self:
#				node.is_active = false
	elif event.is_action('left_click'):
		constants.selectedCar = self
		get_node("../../GUI/HBoxContainer").get_child(self.get_index())._on_TextureButton_pressed()
#		if event.is_action('left_click'):
#			is_active = true
#			for node in get_parent().get_children():
#				if node != self:
#					node.is_active = false
#		constants.selectedCar = self
	


func _load(params):
	get_node("body").mesh = load(params['body'])
	get_node("wheels/fl").mesh = load(params['wheelFront'])
	get_node("wheels/fr").mesh = load(params['wheelFront'])
	get_node("wheels/rl").mesh = load(params['wheelBack'])
	get_node("wheels/rr").mesh = load(params['wheelBack'])
	self.hp = params['hp']
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

func load_modules(params):
	var modules_node = get_node("body/weapons")
	modules_node.add_child(load("res://models/engine.tscn").instance())
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
	for i in abilities.size():
		sliders.append(0)
	constants.sliders[name] = self.sliders



func calc_en_drain():
	energy_drain = 0
	var c = 0
	for module in get_node("body/weapons").get_children():
		energy_drain += sliders[c] * module.energy_cost
		c += 1

	pass


