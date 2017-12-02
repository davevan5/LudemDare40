extends Node2D

var platform_factory
var spawn_timer = 0.0

const PLATFORM_SPAWN_RATE = 2.0

func _ready():
	platform_factory = preload("res://Scenes/Platform/Platform.tscn")
	set_process(true)
	
func _process(delta):
	spawn_timer += delta
	if spawn_timer < PLATFORM_SPAWN_RATE:
		return
	
	spawn_timer -= PLATFORM_SPAWN_RATE
	var platform1 = platform_factory.instance();
	var platform2 = platform_factory.instance();
	platform1.spawn(1, 150)
	platform2.spawn(2, 150)
	add_child(platform1)
	add_child(platform2)