extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var slot_type
var weapon
var slot
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_item(item):
	if item.type == "weapon":
		slot = item
		get_node("TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
		get_parent().get_parent().get_parent().get_parent().taken_node.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_weapon_gui_input():
	if get_parent().get_parent().get_parent().get_parent().taken_node:
		change_item(get_parent().get_parent().get_parent().get_parent().taken_node)

