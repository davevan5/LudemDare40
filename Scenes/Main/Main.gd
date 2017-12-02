extends Node2D

var platform_factory
var spawn_timer = 0.0

const PLATFORM_SPAWN_RATE = 2.0

var player1;
var player2;

var player1_start_location;
var player2_start_location;

var platform_container;

func _ready():
	platform_container = get_node("PlatformContainer")
	
	platform_factory = preload("res://Scenes/Platform/Platform.tscn")
	
	player1 = get_node("Player1");
	player2 = get_node("Player2");
	
	player1_start_location = player1.get_pos();
	player2_start_location = player2.get_pos();
	
	player1.connect("player_died", self, "on_player1_died")
	player2.connect("player_died", self, "on_player2_died")
	
	set_process(true)

func on_player1_died(): 
	reset_game()

func on_player2_died():
	reset_game()
	
func reset_game():
	player1.set_pos(player1_start_location);
	player2.set_pos(player2_start_location);
	
	for platform in platform_container.get_children():
		platform_container.remove_child(platform);
		platform.queue_free()
	

func _process(delta):
	spawn_timer += delta
	if spawn_timer < PLATFORM_SPAWN_RATE:
		return
	
	spawn_timer -= PLATFORM_SPAWN_RATE
	spawn_platform(1, 2)
	spawn_platform(2, 2)

func spawn_platform(player, count):
	var platform = platform_factory.instance()
	add_child(platform)
	platform.spawn(player, count)