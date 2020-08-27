extends Spatial


var death_zones = [Vector2(1, 2.14), Vector2(1, 2.14)]


# Called when the node enters the scene tree for the first time.
func _ready():
	var c = 0
	for child in get_children():
		child.death_zone = death_zones[c]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
