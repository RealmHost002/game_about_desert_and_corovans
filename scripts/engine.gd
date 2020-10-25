extends Position3D


var type = 'engine'
var image_path = "res://icon.png"
var is_pressable = true
var have_slider = true
var toggle = true
var energy_cost = 20.0
var active = false
var mastercar
# Called when the node enters the scene tree for the first time.
func _ready():
	mastercar = get_parent().get_parent().get_parent()
	pass # Replace with function body.

func activate():
	print('some')
	if active:
		active = false
		mastercar.engine_energy_cost = 0
		mastercar.energy_drain -= energy_cost
		mastercar.engine_working = 0
#		mastercar.energy_drain -= energy_cost
	else:
		active = true
		mastercar.engine_energy_cost = energy_cost
		mastercar.energy_drain += energy_cost
		mastercar.engine_working = 1
#		mastercar.energy_drain += energy_cost

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	get_parent().get_parent().get_parent().energy_production
	pass

func _load(params):
	pass
