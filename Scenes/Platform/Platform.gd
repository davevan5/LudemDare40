extends Node2D

var body

const DIRECTION = Vector2(0.0, 1.0)
const INITIAL_SPEED = 150

func _process(delta):
	var body_pos = body.get_pos()
	if body_pos.y > 736:
		queue_free()
		return
	
	body_pos += DIRECTION * INITIAL_SPEED * delta
	body.set_pos(body_pos)

func _ready():
	body = get_node("KinematicBody2D")
	body.set_pos(Vector2(200, 10))
	set_process(true)

func set_width(width):
	get_node("KinematicBody2D/MiddleSprite").set_region_rect(Rect2(0, 0, width, 32))