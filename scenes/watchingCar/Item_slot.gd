extends Panel


var slot_type
var subtype
var weapon
var slot
var inf_from_dict = "empty"
var master_node
var five_parent
# Called when the node enters the scene tree for the first time.
func _ready():
	master_node = get_parent().get_parent().get_parent().get_parent().get_parent()
	if self.get_name().substr(0,6) == "weapon":
		slot_type = "weapon"
	else:
		slot_type = "item"
#	print(slot_type)
	five_parent = get_parent().get_parent().get_parent().get_parent().get_parent()  

func change_item(item):
	print(item.type)
	if item.type == slot_type:
		slot = item
		
#		print("///////////////////////////////////////")
#		print(slot)
#		print("///////////////////////////////////////")
#
#		master_node.taken_node.pop_one()
		if item.type == "weapon":
			get_node("TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
		else:
			if Saveload.shields_data.get(item.i):
				get_node("TextureRect").texture = load(Saveload.shields_data[item.i]["image_path"])
				subtype = "shields_data"
			if Saveload.generators_data.get(item.i):
				get_node("TextureRect").texture = load(Saveload.generators_data[item.i]["image_path"])
				subtype = "generators_data"
		if master_node.taken_node:
			master_node.taken_node.queue_free()
	else:
		print("pupa", item.i)
		master_node.invetoryData[item.i]["count"] += 1
		return
	if inf_from_dict != "empty": 
		# inf_from_dict is the name of weapon/item (like "lasergun")
		master_node.invetoryData[inf_from_dict]["count"] += 1
		var prev_item = inf_from_dict
		inf_from_dict = slot.i #the name of weapon
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
#		print(number_of_weapon)
		#car_inf eto s jsona pro mashinku
		if slot_type =="weapon":
			master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["weapons"][number_of_weapon] = inf_from_dict
			Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
			Saveload._update()
		else:
			if prev_item in master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"]:
#				print(master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].erase(prev_item)
#				print("zaeresil ", prev_item)
#				print(master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
#				Saveload.ourTeamData["config"][number_of_car]["shields"].erase(prev_item)
			elif prev_item in master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"]:
#				print(master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].erase(prev_item)
#				print("zaeresil ", prev_item)
#				print(master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
#				Saveload.ourTeamData["config"][number_of_car]["generator"].erase(prev_item)
			else:
				print("Comrad, you obosralis'")
			if subtype == "shields_data":
				print("pered_appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].append(inf_from_dict)
#				Saveload.ourTeamData["config"][number_of_car]["shields"].append(inf_from_dict)
				Saveload._update()
				print("appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
			elif subtype == "generators_data":
				print("pered_appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].append(inf_from_dict)
#				Saveload.ourTeamData["config"][number_of_car]["generator"].append(inf_from_dict)
				Saveload._update()
				print("appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
	else:
		# inf_from_dict is the name of weapon/item (like "lasergun")
		inf_from_dict = slot.i #the name of weapon
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
#		#car_inf eto s jsona pro mashinku
		if slot_type =="weapon":
			master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["weapons"][number_of_weapon] = inf_from_dict
			Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
			Saveload._update()
		else:
			if subtype == "shields_data":
#				print("pered_appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"].append(inf_from_dict)
#				Saveload.ourTeamData["config"][number_of_car]["shields"].append(inf_from_dict)
				Saveload._update()
#				print("appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["shields"])
			elif subtype == "generators_data":
#				print("pered_appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
				master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"].append(inf_from_dict)
#				Saveload.ourTeamData["config"][number_of_car]["generator"].append(inf_from_dict)
				Saveload._update()
#				print("appaned", master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["generator"])
#	print("inf from saveload shield ", Saveload.ourTeamData["config"][0]["shields"])
#	print("inf from saveload ", Saveload.ourTeamData["config"][0]["generator"])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func drop_item_to_inventory():  #droping item from slot to inventory
	print("inf_from_dict ",inf_from_dict, "slot ",slot)
	if inf_from_dict != "empty":
		get_parent().get_parent().get_parent().get_parent().get_parent().invetoryData[inf_from_dict]['count'] += 1
		get_parent().get_parent().get_parent().get_parent().get_parent().update()
		#in watching_car gd
		get_node("TextureRect").texture = null
		inf_from_dict = "empty"
#		slot.queue_free()
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
		Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
		Saveload._update()
		print("dropping")
		
func _on_weapon_gui_input():
	master_node.current_button = self
	
func _input(event):
	if master_node.current_button:
		if event.is_action_pressed("right_click") and master_node.current_button == self :
			print("current_button ",  master_node.current_button)
#			drop_item_to_inventory()
			if slot_type == "weapon":
				change_item(five_parent.get_node("Panel/ScrollContainer/hcontainer").get_children()[-1])
			else:
				change_item(five_parent.get_node("Panel/ScrollContainer/hcontainer").get_children()[-2])
#	if master_node.taken_node:
#		change_item(master_node.taken_node)



func _on_weapon2_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.


func _on_weapon1_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.


func _on_item1_mouse_entered():
	master_node.current_button = self
	pass # Replace with function body.


func _on_item3_mouse_entered():
	master_node.current_button = self
	pass # Replace with function body.


func _on_item2_mouse_entered():
	master_node.current_button = self
	pass # Replace with function body.


func _on_item1_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.


func _on_item3_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.


func _on_item2_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.
