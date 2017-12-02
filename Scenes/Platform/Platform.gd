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

func spawn(player, count):
	var width = (count + 2) * BLOCK_WIDTH
	var midwidth = width / 2
	
	get_node("PlatformBody/PlatformCollision") \
		.get_shape().set_extents(Vector2(midwidth, 16))
	
	var left = BLOCK_WIDTH_MID - midwidth
	var right = midwidth - BLOCK_WIDTH_MID
	get_node("PlatformBody/LeftSprite").set_pos(Vector2(left, 0))
	get_node("PlatformBody/RightSprite").set_pos(Vector2(right, 0))
	
	for i in range(count):
		i += 1
		var block = block_factory.instance()
		var x = (i * BLOCK_WIDTH) + left
		block.set_pos(Vector2(x, 0))
		get_node("PlatformBody").add_child(block)
	
	randomize()
	if player == 1:
		set_pos(Vector2(randi()%400+100, 10))
	else:
		set_pos(Vector2(randi()%400+800, 10))