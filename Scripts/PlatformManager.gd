extends Node2D

var platform_scene
var platform_speed = 100
var game_timer = 0.0
var spawn_rate = 2.0

func _ready():
	platform_scene = preload("res://Scenes/Platform/Platform.tscn")
	set_process(true)

func _process(delta):
	game_timer += delta	
	if game_timer < spawn_rate:
		return
	
	game_timer -= spawn_rate
	randomize()
	create(0, randi()%3+1)
	create(1, randi()%3+1)
	create(2, randi()%3+1)
	create(3, randi()%3+1)

func create(area, count):
	var platform = platform_scene.instance()
	platform.spawn(area, count)
	platform.set_speed(platform_speed)
	add_child(platform)

func get_speed():
	return platform_speed

func set_speed(speed):
	platform_speed = speed
	for platform in get_children():
		platform.set_speed(speed)

func reset():
	game_timer = 0.0
	for platform in get_children():
		remove_child(platform)
		platform.free()