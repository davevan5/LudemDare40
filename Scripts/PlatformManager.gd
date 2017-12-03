extends Node2D

const MIN_RATE = 1.0
const MAX_RATE = 2.5

var platform_scene
var platform_speed = 100
var rate = [1.6, 0.4, 2.0, 0.2]
var timer = [0.0, 0.0, 0.0, 0.0]

func _ready():
	platform_scene = preload("res://Scenes/Platform/Platform.tscn")
	set_process(true)

func _process(delta):
	for i in range(4):
		timer[i] += delta
		if timer[i] > rate[i]:
			create(i)

func create(zone):
	randomize()
	timer[zone] -= rate[zone]
	rate[zone] = randf()*MAX_RATE + MIN_RATE

	var platform = platform_scene.instance()
	platform.spawn(zone)
	platform.set_speed(platform_speed)
	add_child(platform)

func get_speed():
	return platform_speed

func set_speed(speed):
	platform_speed = speed
	for platform in get_children():
		platform.set_speed(speed)

func reset():
	timer = [0.0, 0.0, 0.0, 0.0]
	rate = [1.6, 0.4, 2.0, 0.2]

	for platform in get_children():
		remove_child(platform)
		platform.free()