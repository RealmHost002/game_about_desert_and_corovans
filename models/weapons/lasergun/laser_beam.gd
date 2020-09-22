extends MeshInstance


#var speed = 1.0
var lifetime = .3
#var some_color = Color(1.0, 0.0, 0.0, 1.0)
var some_vector = Vector2(0.0, 0.0)
# Called when the node enters the scene tree for the first time.
func _ready():
#	self.set_surface_material(0, self.get_surface_material(0).duplicate(true))

#	get_node("AnimationPlayer").playback_speed = speed
#	lifetime /= speed

#	some_color.r = randf()
#	some_color.g = 1 - some_color.r
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	some_color.r -= delta / lifetime
#	some_color.a -= delta / lifetime
	some_vector.x += delta / lifetime
#	 / lifetime
#	print(some_vector.x)
#	self.get_surface_material(0).set_shader_param("albedo", some_color)
#	print(some_vector)
	self.get_surface_material(0).set_shader_param("a", some_vector.x)
#	lifetime -= delta
	if some_vector.x >= 1:
		queue_free()
