extends Node

var rng = RandomNumberGenerator.new()
var step_time = 4.0
var input_mode = 'car_select'
var selectedCar
var weapon_check_terrain_step = 0.1
var sliders = {}
var selected_weapon

var default_resolution = Vector2(1920.0, 1080.0) * 2.0
var machine_resolution = Vector2(1920.0, 1080.0)
var res_mult = Vector2(1.0, 1.0)
# Called when the node enters the scene tree for the first time.
func _ready():
#	default_resolution = 
	machine_resolution = OS.get_window_size()
	res_mult.x = default_resolution.x / machine_resolution.x
	res_mult.y = default_resolution.y / machine_resolution.y
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

