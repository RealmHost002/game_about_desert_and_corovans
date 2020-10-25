extends Position3D


var type = 'generator'
var image_path = "res://icon.png"
var is_pressable = false
var have_slider = false
var toggle = false
var energy_production = 0.0
var max_energy = 0.0
var energy_cost = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _load(params):
	energy_production = params['energy_production']
	max_energy = params['max_energy']
	image_path = params['image_path']
	get_parent().get_parent().get_parent().energy_production += energy_production
	get_parent().get_parent().get_parent().max_energy += max_energy
