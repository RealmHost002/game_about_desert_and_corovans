extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var slot_type
var weapon
var slot
var inf_from_dict
var master_node
# Called when the node enters the scene tree for the first time.
func _ready():
	master_node = get_parent().get_parent().get_parent().get_parent().get_parent()
	if self.get_name().substr(0,6) == "weapon":
		slot_type = "weapon"
	else:
		slot_type = "item"
#	print(slot_type)

func change_item(item):
	if item.type == slot_type:
		slot = item
#		master_node.taken_node.pop_one()
		get_node("TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
		master_node.taken_node.queue_free()
	if inf_from_dict != "empty":
		master_node.invetoryData[inf_from_dict]["count"] += 1
		inf_from_dict = slot.i #the name of weapon
		var number_of_car = get_parent().get_parent().get_parent().inf_from_dict["cars"] - 1
		var number_of_weapon = self.name.to_int() - 1
#		print(number_of_weapon)
		master_node.get_node("Panel2/GridContainer").get_child(number_of_car).car_inf["weapons"][number_of_weapon] = inf_from_dict
		print("///////////////////////////////////////")
		print(Saveload.ourTeamData)
		print("///////////////////////////////////////")
		print("number_of_car ", number_of_car," number_of_weapon ",number_of_weapon )
		Saveload.ourTeamData["config"][number_of_car]["weapons"][number_of_weapon] = inf_from_dict
		Saveload._update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weapon_gui_input():
	master_node.current_button = self
#	if master_node.taken_node:
#		change_item(master_node.taken_node)



func _on_weapon2_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.


func _on_weapon1_mouse_exited():
	master_node.current_button = 0
	pass # Replace with function body.
