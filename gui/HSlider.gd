extends HSlider


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_HSlider_value_changed(value):
	get_child(0).text = str(self.value) + "%"
	if constants.selectedCar:
		constants.selectedCar.slider_changed(get_parent().selectedWeapon, value)
	pass # Replace with function body.
