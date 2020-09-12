extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var weapon_type = "small"
var weapon
var item1
var item2
var current_car
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_item(item):
	if item.type == "weapon":
		weapon = item
		get_node("TextureRect/weapon/TextureRect").texture = load(Saveload.weapon_data[item.i]["image_path"])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
