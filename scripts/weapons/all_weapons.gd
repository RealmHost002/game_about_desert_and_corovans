extends Spatial


var death_zones = [Vector2(1, 2.14), Vector2(4.14, 5.28), Vector2(1, 2.14)]


# Called when the node enters the scene tree for the first time.
func _ready():
	var c = 1
	for i in range(1,3,1):
#		print(i)
		get_child(i).death_zone = death_zones[i-1]
#		c += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
