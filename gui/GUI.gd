extends Control
#Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mode = 'game'
var selectedCar = 0

# Called when the node enters the scene tree for the first time.

func _ready():
#	print(constants.res_mult)
	self.rect_scale = constants.res_mult
	
	
#	print(get_tree().get_nodes_in_group('ally').size())
	AddingFuckingEgors(get_tree().get_nodes_in_group('ally').size())
	AddingWeaponButtons()
	pass # Replace with function body.
func AddingFuckingEgors(a):
	var counter = 0
	for i in a:
		var TopIconScene = load("res://gui/TopIcon.tscn").instance()
		get_node("HBoxContainer").add_child(TopIconScene)
		TopIconScene.number = counter
		counter += 1

func AddingWeaponButtons():
	if !constants.selectedCar:
		return
	var counter = 0
	
	var weapons = constants.selectedCar.get_node("body/weapons").get_children()
	for i in weapons:
		var WeaponIconScene = load("res://gui/weaponIcon.tscn").instance()
		get_node("HBoxContainer2/weaponContainer").add_child(WeaponIconScene)
		WeaponIconScene.selectedWeapon = counter
		var texture = load(i.image_path)
		var i_place = i.image_path.find(".")
#		print(str(i_place) + "vot tut")
		var pipka = i.image_path
		pipka.erase(i_place, 4)
		var texture_click = load(pipka + "_clicked.png")
#		var texture_busy = load(i.image_path)
		WeaponIconScene.set_normal_texture(texture)
		WeaponIconScene.set_pressed_texture(texture_click)
		if not i.have_slider:
			WeaponIconScene.get_node("HSlider").hide()
		if i.toggle:
			WeaponIconScene.toggle_mode = true
			WeaponIconScene.pressed = i.active
		counter += 1
		
func setting_car_params():
	var labels_parent = get_node("HBoxContainer2/TextureButton/VSeparator/Panel")
	
	if constants.selectedCar:
		get_node("HBoxContainer2/TextureRect").texture = load("res://gui/textures/portrets/" + constants.selectedCar.hull +".png")
		get_node("HBoxContainer2/TextureRect/Label").text = constants.selectedCar.hull
		labels_parent.get_node("hp_label").text = "Hp: " + str(constants.selectedCar.hp)
		labels_parent.get_node("energy_label").text = "Energy: " + str(constants.selectedCar.energy)		
		labels_parent.get_node("shield_label").text = "Shield: " + str(constants.selectedCar.shield)	
		labels_parent.get_node("energy_regen_label").text = "Energy regen: " + str(constants.selectedCar.energy_production)
		labels_parent.get_node("energy_wasting").text = "Energy drain: " + str(constants.selectedCar.energy_drain)		
		var right_panel = get_node("HBoxContainer2/TextureButton/VSeparator/right_panel")
		if constants.selected_weapon:
			if constants.selected_weapon.type == "weapon":
				right_panel.get_node("Name").text = constants.selected_weapon._name
				right_panel.get_node("type").text = constants.selected_weapon.damage_type
				right_panel.get_node("distance").text = "Distance: " + str(constants.selected_weapon.distance)
				right_panel.get_node("damage").text = "Damage: " + str(constants.selected_weapon.damage)
				if constants.selected_weapon.damage_type == "laser":
					right_panel.get_node("type").add_color_override("font_color",Color(0,151,179,255)) 
				else:
					right_panel.get_node("type").set("custom_colors/font_color",Color(255,255,255,255)) 
		else:
			right_panel.get_node("Name").text = "drochilla"
		
		for button_id in get_node("HBoxContainer2/weaponContainer").get_child_count():
			var w = constants.selectedCar.get_node('body/weapons').get_child(button_id)
			if w.type == 'weapon':
				var b = get_node("HBoxContainer2/weaponContainer").get_child(button_id)
				if w.max_cd_time:
					b.get_node('TextureProgress').material.set_shader_param('a', w.current_cd_time / w.max_cd_time)
				else:
					b.get_node('TextureProgress').material.set_shader_param('a', 0.0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("open_inventory"):
		if get_node("../invetory").is_visible():
			get_node("../invetory").hide()
		else:
			get_node("../invetory").show()

	if event.is_action_pressed("map"):
		if get_node("../map/camera_look_at/Camera").current:
			get_node("../camera_look_at/Camera").current = true
			get_node("../map/camera_look_at/Camera").current = false
			get_node("../camera_look_at/Camera").drag_speed = 10.0
			get_node("../map/camera_look_at/Camera").anti_speed = 20.0
		else:
			get_node("../camera_look_at/Camera").current = false
			get_node("../map/camera_look_at/Camera").current = true
			get_node("../map/camera_look_at/Camera").drag_speed = 1.0
			get_node("../map/camera_look_at/Camera").anti_speed = 200.0

func _process(delta):
	setting_car_params()
	get_node('Label').text = str(Engine.get_frames_per_second())
	for button in get_node("HBoxContainer2/weaponContainer").get_children():
		if constants.input_mode == 'only_move':
			button.button_mask = 0
			button.set_enabled_focus_mode(false)
		else:
			button.button_mask = BUTTON_MASK_LEFT
			
	pass
