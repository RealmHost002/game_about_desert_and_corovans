extends Spatial

var gamestate = true #true if unpause, false if pause


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("StepTimer").wait_time = constants.step_time
#	for node in get_node("../cars").get_children():
#		node.set_process(false)
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("TEST_BUTTON_1"):
		GAME_UNPAUSE()

func GAME_UNPAUSE():
	for node in get_node("../cars").get_children():
		node.set_process(true)
		node.hide_path()
		gamestate = 1
		get_node("StepTimer").start()

func GAME_PAUSE():
	for node in get_node("../cars").get_children():
		node.set_process(false)
		node.show_path()
		gamestate = 0

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if !gamestate and event.is_action('left_click'):
		for node in get_node("../cars").get_children():

			if node.is_active:
				node.destination = click_position
				node.destination.y = 2
#				var m = MeshInstance.new()
#				m.mesh = load("res://new_cubemesh.tres")
#				get_node("Mypath").add_child(m)
		#		m.scale = Vector3(10, 10, 10)
#				m.global_transform.origin = destination
				node.show_path()



func _on_StepTimer_timeout():
	GAME_PAUSE()
	pass # Replace with function body.
