extends Node

var rng = RandomNumberGenerator.new()
var step_time = 2.0
var input_mode = 'car_select'
var selectedCar
var weapon_check_terrain_step = 0.1
var sliders = {}
var selected_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
