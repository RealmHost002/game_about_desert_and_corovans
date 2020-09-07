extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var counter = 0
var selectedCar = 0

# Called when the node enters the scene tree for the first time.

func _ready():
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
		WeaponIconScene.set_normal_texture(texture)
		if not i.have_slider:
			WeaponIconScene.get_node("HSlider").hide()
		
		counter += 1
		
func setting_car_params():
	var labels_parent = get_node("HBoxContainer2/TextureButton/VSeparator/Panel")
	if constants.selectedCar:
		labels_parent.get_node("hp_label").text = "Hp: " + str(constants.selectedCar.hp)
		labels_parent.get_node("energy_label").text = "Energy: " + str(constants.selectedCar.energy)		
		labels_parent.get_node("shield_label").text = "Shield: " + str(constants.selectedCar.shield)	
		labels_parent.get_node("energy_regen_label").text = "Energy regen: " + str(constants.selectedCar.energy_production)
		labels_parent.get_node("energy_wasting").text = "Energy drain: " + str(constants.selectedCar.energy_drain)		
		var right_panel = get_node("HBoxContainer2/TextureButton/VSeparator/right_panel")
		if constants.selected_weapon:
#			print(constants.selected_weapon)
			if constants.selected_weapon.type == "weapon":
				right_panel.get_node("Name").text = constants.selected_weapon._name
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	setting_car_params()
	pass
