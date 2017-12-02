extends Node2D

var platform_factory
var spawn_timer = 0.0

const PLATFORM_SPAWN_RATE = 1.4

func _ready():
	platform_factory = preload("res://Scenes/Platform.tscn")
	set_process(true)
	
func _process(delta):
	spawn_timer += delta
	if spawn_timer < PLATFORM_SPAWN_RATE:
		return
	
	spawn_timer -= PLATFORM_SPAWN_RATE
	var platform = platform_factory.instance()
	platform.set_width(150)
	add_child(platform)