extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var slot_type
var weapon
var slot
var inf_from_dict
# Called when the node enters the scene tree for the first time.
func _ready():
	if self.get_name().substr(0,6) == "weapon":
		slot_type = "weapon"
	else:
		slot_type = "item"
#	print(slot_type)

func change_item(item):
	if item.type == slot_type:
		slot = item
#		print(slot)
		get_node("TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
		get_parent().get_parent().get_parent().get_parent().get_parent().taken_node.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weapon_gui_input():
	if get_parent().get_parent().get_parent().get_parent().get_parent().taken_node:
		change_item(get_parent().get_parent().get_parent().get_parent().get_parent().taken_node)

