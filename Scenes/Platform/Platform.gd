extends Node2D

var block_factory
var body

const BLOCK_WIDTH_MID = 16
const BLOCK_WIDTH = 32
const DIRECTION = Vector2(0.0, 1.0)

var current_speed = 0.0
var count = 1

func _init():
	block_factory = preload("res://Scenes/Platform/Block.tscn")

func _ready():
	body = get_node("PlatformBody")
	set_process(true)

func _process(delta):
	var body_pos = body.get_pos()
	if body_pos.y > 736:
		queue_free()
		return
	
	body_pos += DIRECTION * current_speed * delta
	body.set_pos(body_pos)

func set_block_count(new_count):
	count = new_count

func get_width():
	return (count + 1) * BLOCK_WIDTH

func create(position):
	var shape = CapsuleShape2D.new()
	shape.set_height(get_width())
	shape.set_radius(16)
	get_node("PlatformBody").add_shape(shape, Matrix32().rotated(PI/2))	
	var collision_node = get_node("PlatformBody/PlatformCollision")
	collision_node.set_shape(shape)
	
	var midx = get_width() / 2
	get_node("PlatformBody/LeftSprite").set_pos(Vector2(-midx, 0))
	get_node("PlatformBody/RightSprite").set_pos(Vector2(midx, 0))
	for i in range(count):
		var block = block_factory.instance()
		var x = ((i + 1) * BLOCK_WIDTH) - midx
		block.set_pos(Vector2(x, 0))
		get_node("PlatformBody").add_child(block)

	set_pos(position)

func set_speed(speed):
	current_speed = speed