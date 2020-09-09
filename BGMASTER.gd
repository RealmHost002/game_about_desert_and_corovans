extends Spatial

var gamestate = true #true if unpause, false if pause
var path = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("StepTimer").wait_time = constants.step_time
	GAME_PAUSE()
#	for node in get_node("../cars").get_children():
#		node.set_process(false)
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("TEST_BUTTON_1"):
		GAME_UNPAUSE()
	if event.is_action_pressed("function_1"):
		path = true
	if event.is_action_released("function_1"):
		path = false


func GAME_UNPAUSE():
	for node in get_node("../cars").get_children():
		node.unpause()
		gamestate = 1
		get_node("StepTimer").start()

func GAME_PAUSE():
	for node in get_node("../cars").get_children():
		node.pause()
#		node.set_process(false)
#		node.show_path()
		gamestate = 0

func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
	if constants.selectedCar and event.is_action('left_click') and event.pressed and !path:
		constants.selectedCar.path = []
		constants.selectedCar.destination = click_position
		constants.selectedCar.destination.y = 2
		constants.selectedCar.show_path()
		constants.selectedCar.target_to_follow = 0
	
	elif constants.selectedCar and event.is_action('left_click') and path and event.pressed:
		var d = click_position
		d.y = 2
		if !constants.selectedCar.path:
			constants.selectedCar.path.append(constants.selectedCar.destination)
		constants.selectedCar.path.append(d)
		constants.selectedCar.show_path()
		
#	if !gamestate and event.is_action('left_click'):
#		for node in get_node("../cars").get_children():
#			print(node.is_active)
#			if node.is_active:
#				node.destination = click_position
#				node.destination.y = 2
#				node.show_path()
#				print('path for ', self)


func _on_StepTimer_timeout():
	GAME_PAUSE()
	pass # Replace with function body.
