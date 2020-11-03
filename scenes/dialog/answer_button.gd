extends Button


var link


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_pressed():
	get_parent().get_parent().tag = "g"
	get_parent().get_parent().tag_value = link
	get_parent().get_parent().mode = "making"
	get_parent().get_parent().read_dialog(0)
	get_parent().get_parent().remove_buttons()
