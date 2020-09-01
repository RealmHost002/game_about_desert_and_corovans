extends MeshInstance


var speed = 4.0
var lifetime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").playback_speed = speed
	lifetime /= speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
