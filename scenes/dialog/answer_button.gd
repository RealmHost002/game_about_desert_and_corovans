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
	print("PRESSED")
	if value:
		if link in get_tree().get_root().get_node("Spatial/quests/introduction").data:
			get_tree().get_root().get_node("Spatial/quests/introduction").data[link] = value
		else:
			print("Warning!!! The value is empty! (in dialog in text file when you press the button)")
	get_parent().get_parent().get_node("RichTextLabel").tag = "g"
	get_parent().get_parent().get_node("RichTextLabel").tag_value = link
	get_parent().get_parent().get_node("RichTextLabel").mode = "making"
	get_parent().get_parent().get_node("RichTextLabel").read_dialog(0)
	get_parent().get_parent().get_node("RichTextLabel").remove_buttons()
	
