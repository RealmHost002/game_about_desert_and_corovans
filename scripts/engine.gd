extends Position3D


var type = 'engine'
var image_path = "res://icon.png"
var is_pressable = true
var have_slider = true
var energy_cost = 20.0
var active = false
var mastercar
# Called when the node enters the scene tree for the first time.
func _ready():
	mastercar = get_parent().get_parent().get_parent()
	pass # Replace with function body.

func activate():
	if active:
		active = false
#		mastercar.energy_drain -= energy_cost
	else:
		active = true
#		mastercar.energy_drain += energy_cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_parent().get_parent().get_parent().energy_production
	pass

func _load(params):
	pass
