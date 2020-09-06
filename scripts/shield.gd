extends Position3D

var type = 'shield'
var image_path = "res://icon.png"
var is_pressable = false
var have_slider = true
var shield_production = 0
var max_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _load(params):
#	shield_production = params['shield_production']
	image_path = params['image_path']
	max_value = params['max_value']
