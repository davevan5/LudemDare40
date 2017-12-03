extends Node2D

signal touched(player)

var platform_speed = 0

var physics_object;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	physics_object = get_node("Physics")
	set_fixed_process(true)
	
func _fixed_process(delta):
	var position = get_pos()
	position.y += platform_speed * delta
	set_pos(position)
	
	var collision = physics_object.get_colliding_bodies()
	
	if collision.size() > 0:
		emit_signal("touched", collision[0])
		queue_free()

func create(position):
	set_pos(position - Vector2(0, 16))

func set_speed(speed):
	platform_speed = speed
