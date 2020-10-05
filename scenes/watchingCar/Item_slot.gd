extends Panel


var slot_type
var subtype
#var weapon
var slot
var inf_from_dict = "empty"
var watching_car_node

# Called when the node enters the scene tree for the first time.
func _ready():
	watching_car_node = get_parent().get_parent().get_parent().get_parent().get_parent()
	if self.get_name().substr(0,6) == "weapon":
		slot_type = "weapon"
	else:
		slot_type = "item"
#	print(slot_type)
	watching_car_node = get_parent().get_parent().get_parent().get_parent().get_parent()  
func deleting_plug(item_type):
#	when you drop item to slot with plug you must delete the one
#	that adding into watching_car_node.dictionaryData
#	to set weaponplug ("zzzWeapon") to 0 to not to appear it
#	into watching_car_node -> hcontainer
	if item_type == "weapon":
		watching_car_node.invetoryData["zzzWeapon"]["count"] -= 1
	elif item_type == "item":
		watching_car_node.invetoryData["zzzConvergenator_mk3"]["count"] -= 1
	pass


func change_item(item):
	print(item.type)
	if item.type == slot_type:
		slot = item
		if item.type == "weapon":
			get_node("TextureRect").texture = load(Saveload.weapon_data[item.name_of_weapon_string]["image_path"])
		else:
			if Saveload.shields_data.get(item.name_of_weapon_string):
				get_node("TextureRect").texture = load(Saveload.shields_data[item.name_of_weapon_string]["image_path"])
				subtype = "shields_data"
			if Saveload.generators_data.get(item.name_of_weapon_string):
				get_node("TextureRect").texture = load(Saveload.generators_data[item.name_of_weapon_string]["image_path"])
				subtype = "generators_data"
		if watching_car_node.taken_node:
			watching_car_node.taken_node.queue_free()
	else:
		watching_car_node.invetoryData[item.name_of_weapon_string]["count"] += 1
		return
	if inf_from_dict != "empty": 
		
		# inf_from_dict is the name of weapon/item (like "lasergun")
		if inf_from_dict != "zzzWeapon" and inf_from_dict != "zzzConvergenator_mk3":
			print("SSSSSSSSSS ",inf_from_dict)
			watching_car_node.invetoryData[inf_from_dict]["count"] += 1
		var prev_item = inf_from_dict
		inf_from_dict = slot.name_of_weapon_string #the name of weapon
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
		#car_inf eto s jsona pro mashinku
		if slot_type =="weapon":
			watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["weapons"][number_of_weapon] = inf_from_dict
			Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict 
			Saveload._update()
		else:
			if prev_item in watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"]:
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].erase(prev_item)
			elif prev_item in watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"]:
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].erase(prev_item)
			else:
				print("Comrad, you obosralis'")
			if subtype == "shields_data":
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].append(inf_from_dict)
				Saveload._update()
			elif subtype == "generators_data":
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].append(inf_from_dict)
				Saveload._update()
	else:
		print("NE UDALYAT'!!!!!")# if not appear, than delete this else
		# inf_from_dict is the name of weapon/item (like "lasergun")
		inf_from_dict = slot.i #the name of weapon
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
#		#car_inf eto s jsona pro mashinku
		if slot_type =="weapon":
			watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["weapons"][number_of_weapon] = inf_from_dict
			Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
			Saveload._update()
		else:
			if subtype == "shields_data":
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].append(inf_from_dict)
				Saveload._update()
			elif subtype == "generators_data":
				watching_car_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].append(inf_from_dict)
				Saveload._update()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func drop_item_to_inventory():  #droping item from slot to inventory
#	print("SSSSSSSSSSSSSSSSSSSSSSSSinf_from_dict ",inf_from_dict, "slot ",slot)
	if inf_from_dict != "empty":
		if inf_from_dict != "zzzWeapon" and inf_from_dict != "zzzConvergenator_mk3" :
			watching_car_node.invetoryData[inf_from_dict]['count'] += 1
			watching_car_node.update()
		get_node("TextureRect").texture = null
		inf_from_dict = "empty"
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
		Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
		Saveload._update()
		
func _on_weapon_gui_input():
	watching_car_node.current_button = self
	
func _input(event):
	if watching_car_node.current_button:
		if event.is_action_pressed("right_click") and watching_car_node.current_button == self:
			print("inf_from_dict ",inf_from_dict)
			if slot_type == "weapon" and inf_from_dict != "zzzWeapon" :
#				watching_car_node.invetoryData["zzzWeapon"]["count"] += 1
				change_item(watching_car_node.get_node("Panel/ScrollContainer/hcontainer").get_children()[-1])
			if slot_type == "item" and inf_from_dict != "zzzConvergenator_mk3":
#				watching_car_node.invetoryData["zzzConvergenator_mk3"]["count"] += 1
				change_item(watching_car_node.get_node("Panel/ScrollContainer/hcontainer").get_children()[-2])
			Saveload._update()

#signals
func _on_weapon2_mouse_exited():
	watching_car_node.current_button = 0

func _on_weapon1_mouse_exited():
	watching_car_node.current_button = 0

func _on_item1_mouse_entered():
	watching_car_node.current_button = self

func _on_item3_mouse_entered():
	watching_car_node.current_button = self

func _on_item2_mouse_entered():
	watching_car_node.current_button = self

func _on_item1_mouse_exited():
	watching_car_node.current_button = 0

func _on_item3_mouse_exited():
	watching_car_node.current_button = 0

func _on_item2_mouse_exited():
	watching_car_node.current_button = 0
