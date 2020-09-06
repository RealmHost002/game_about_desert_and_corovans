extends Position3D


var type = 'generator'
var image_path = "res://icon.png"
var is_pressable = false
var have_slider = false
var energy_production = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _load(params):
	energy_production = params['energy_production']
	image_path = params['image_path']
	get_parent().get_parent().get_parent().energy_production += energy_production
