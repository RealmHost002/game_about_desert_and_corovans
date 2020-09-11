extends StaticBody

var type = 'shield'
var image_path = "res://icon.png"
var is_pressable = false
var have_slider = true
var shield_production = 0
var max_value = 0
var energy_cost = 0
var current_sh_gen = 0
var current_en_cost = 0
var shield = 0
#var radius = 
var mastercar
# Called when the node enters the scene tree for the first time.
func _ready():
	mastercar = get_parent().get_parent().get_parent()
	self.connect("input_event", mastercar, "_on_input_event")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func enable_shield():
	if mastercar.energy > current_en_cost:
		shield = current_sh_gen
		mastercar = get_parent().get_parent().get_parent()
		mastercar.energy -= current_en_cost
		mastercar.shield += current_sh_gen
		if current_sh_gen > 0:
			self.show()
	else:
		pass


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


func take_damage(damage, weaponType, status = "no"):
	mastercar.shield -= self.shield
	if damage >= shield:
		damage -= shield
		mastercar.take_damage(damage, weaponType, status)
		shield = 0
		self.hide()
#		print('gg_wp')
	else:
		shield -= damage
#		print(shield) 
	mastercar.shield += self.shield
	pass



