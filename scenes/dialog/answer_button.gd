extends Button


var link
var value


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_pressed():
	if value:
		if link in get_tree().get_root().get_node("Spatial/quests/introduction").data:
			get_tree().get_root().get_node("Spatial/quests/introduction").data[link] = value
		else:
			print("Warning!!! The value is empty! (in dialog in text file when you press the button)")
	get_parent().get_parent().tag = "g"
	get_parent().get_parent().tag_value = link
	get_parent().get_parent().mode = "making"
	get_parent().get_parent().read_dialog(0)
	get_parent().get_parent().remove_buttons()
	
