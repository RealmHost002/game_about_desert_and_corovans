extends Control



var weapon_type = "small"
var weapon
var inf_from_dict #stroke about current car from save.json
var current_car
# Called when the node enters the scene tree for the first time.
func _ready():
	_load()
	pass 

func _load():

	var other_items = inf_from_dict["shields"]
	if !other_items[-1]:
		other_items.pop_back()
	other_items = other_items + inf_from_dict["generator"]
	if !other_items[-1]:
		other_items.pop_back()
	var counter = 0
	var counter2 = 0
	for i in get_node("TextureRect/items").get_children():
		if i.slot_type == "weapon":
#			print("................................")
			if inf_from_dict["weapons"].size() - 1 >= counter:
				i.inf_from_dict = inf_from_dict["weapons"][counter]
				counter += 1
				i.get_node("TextureRect").texture = load(Saveload.weapon_data[i.inf_from_dict]["image_path"])
			else:	
				i.inf_from_dict = "empty"
		else:
			if other_items.size() - 1 >= counter2:
				i.inf_from_dict = other_items[counter2]
				if other_items[counter2] in Saveload.generators_data:
					i.get_node("TextureRect").texture = load(Saveload.generators_data[i.inf_from_dict]["image_path"])
				elif other_items[counter2] in Saveload.shields_data:
					i.get_node("TextureRect").texture = load(Saveload.shields_data[i.inf_from_dict]["image_path"])		
				counter2 += 1
			else:	
				i.inf_from_dict = "empty"

func change_item(item):
	if item.type == "weapon":
		weapon = item
		get_node("TextureRect/weapon/TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weapon_gui_input(event):
	pass # Replace with function body.
