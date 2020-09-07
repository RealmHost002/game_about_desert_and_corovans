extends Position3D

var type = 'shield'
var image_path = "res://icon.png"
var is_pressable = false
var have_slider = true
var shield_production = 0
var max_value = 0
var energy_cost = 0
var current_sh_gen = 0
var current_en_cost = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func slider_changed(v):
	current_sh_gen = v / 100.0 * max_value
	current_en_cost = v / 100.0  * energy_cost
	if v == 0:
		self.hide()
	print(v)
	
func _load(params):
#	shield_production = params['shield_production']
	image_path = params['image_path']
	max_value = params['max_value']
	energy_cost= params['energy_cost']
