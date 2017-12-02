extends Node2D

var block_factory
var body

const BLOCK_WIDTH_MID = 16
const BLOCK_WIDTH = 32
const DIRECTION = Vector2(0.0, 1.0)
const INITIAL_SPEED = 100

func _ready():
	body = get_node("PlatformBody")
	block_factory = preload("res://Scenes/Platform/Block.tscn")
	set_process(true)

func _process(delta):
	var body_pos = body.get_pos()
	if body_pos.y > 736:
		queue_free()
		return
	
	body_pos += DIRECTION * INITIAL_SPEED * delta
	body.set_pos(body_pos)

func spawn(area, count):
	var width = (count + 2) * BLOCK_WIDTH
	var midwidth = width / 2
	
	var shape = CapsuleShape2D.new()
	shape.set_height(width)
	shape.set_radius(16)
	
	get_node("PlatformBody").add_shape(shape, Matrix32().rotated(PI/2))
	
	var collision_node = get_node("PlatformBody/PlatformCollision")
	collision_node.set_shape(shape)
	collision_node.set_trigger(false)
	

	get_node("PlatformBody/LeftSprite").set_pos(Vector2(-midwidth, -16))
	get_node("PlatformBody/RightSprite").set_pos(Vector2(midwidth - BLOCK_WIDTH, -16))
	
	for i in range(count):
		i += 1
		var block = block_factory.instance()
		var x = (i * BLOCK_WIDTH) - midwidth
		block.set_pos(Vector2(x, 0))
		get_node("PlatformBody").add_child(block)
	
	randomize()
	var min_x = (area * 300) + midwidth
	set_pos(Vector2((randi() % (300 - width)) + min_x, 10))