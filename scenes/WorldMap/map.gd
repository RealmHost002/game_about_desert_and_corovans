extends Spatial


var m_pos = Vector3(-40, 0, -40)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	
	

func PAUSE():
	for child in get_node("corovans").get_children():
		child.pause()

func UNPAUSE():
	for child in get_node("corovans").get_children():
		child.unpause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if event.is_action('left_click'):
		get_node('corovans').get_child(0).set_path(click_position - m_pos)
		print(click_position - m_pos)
	pass # Replace with function body.
