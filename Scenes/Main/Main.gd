extends Node2D

enum State {
	COUNTDOWN,
	PLAYING
}

var state = State.COUNTDOWN;

var platform_factory
var spawn_timer = 0.0

var countdown_timer = 0.0

const BOAT_WAIT_TIME = 7
var boat_movement_timer = 0.0

const MIN_SPAWN_RATE = 1.0
const MAX_SPAWN_RATE = 2.0
const INITIAL_PLATFORM_SPEED = 100

var platform_speed = INITIAL_PLATFORM_SPEED

var player1;
var player2;

var player1_start_location;
var player2_start_location;

var countdown_text;
var platform_container;
var boat_node;

func _ready():
	platform_container = get_node("PlatformContainer")
	
	platform_factory = preload("res://Scenes/Platform/Platform.tscn")
	
	countdown_text = get_node("RichTextLabel")
	
	player1 = get_node("Player1")
	player2 = get_node("Player2")
	
	player1_start_location = player1.get_pos()
	player2_start_location = player2.get_pos()
	
	player1.connect("player_died", self, "on_player1_died")
	player2.connect("player_died", self, "on_player2_died")
	
	boat_node = get_node("BoatContainer/Boat")
	
	reset_game()
	
	set_process(true)

func on_player1_died(): 
	reset_game()

func on_player2_died():
	reset_game()
	
func reset_game():
	player1.set_pos(player1_start_location)
	player2.set_pos(player2_start_location)
	
	boat_movement_timer = 0
	countdown_timer = 0
	countdown_text.set_text("Get Ready!")
	countdown_text.show()
	state = State.COUNTDOWN
	
	boat_node.set_pos(Vector2(0, 0))
	
	for platform in platform_container.get_children():
		platform_container.remove_child(platform)
		platform.free()
	
	adjust_platform_speed(INITIAL_PLATFORM_SPEED)

func _process(delta):
	if state == State.COUNTDOWN:
		countdown_timer += delta
		var remaining = 3 - (floor(countdown_timer))
		if (remaining == 0):
			remaining = "GO!"
		
		if (countdown_timer >= 4):
			countdown_text.hide()
			state = State.PLAYING
			
		countdown_text.set_text(String(remaining))
		return
	
	update_boat(delta)
	
	spawn_timer += delta
	if spawn_timer < MAX_SPAWN_RATE:
		return
	
	spawn_timer -= MAX_SPAWN_RATE
	randomize()
	spawn_platform(0, randi()%3+1)
	spawn_platform(1, randi()%3+1)
	spawn_platform(2, randi()%3+1)
	spawn_platform(3, randi()%3+1)

func spawn_platform(area, count):
	var platform = platform_factory.instance()
	platform_container.add_child(platform)
	platform.spawn(area, count)
	platform.set_speed(platform_speed)
	
func adjust_platform_speed(speed):
	platform_speed = speed
	player1.set_platform_speed(speed)
	player2.set_platform_speed(speed)
	
	for platform in platform_container.get_children():
		platform.set_speed(speed)
	
func update_boat(delta):
	var boat_pos = boat_node.get_pos()
	
	if boat_pos.y > 720:
		return

	if boat_movement_timer < BOAT_WAIT_TIME:
		boat_movement_timer += delta
		return

	randomize()
	var adjustment = (randi() % 10) - 5
	boat_pos.x = adjustment
	boat_pos.y += platform_speed * delta
	boat_node.set_pos(boat_pos)