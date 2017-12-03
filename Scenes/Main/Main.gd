extends Node2D

enum State {
	COUNTDOWN,
	PLAYING
}

const BOAT_WAIT_TIME = 7
const INITIAL_PLATFORM_SPEED = 100

var state = State.COUNTDOWN
var countdown_timer = 0.0
var boat_movement_timer = 0.0

var player1
var player2
var player1_start_location
var player2_start_location

var countdown_text
var boat_node
var platform_manager

func _ready():
	get_node("SamplePlayer").play("music")
	
	platform_manager = get_node("PlatformManager")

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
	platform_manager.set_process(false)
	platform_manager.reset()
	
	player1.set_pos(player1_start_location)
	player2.set_pos(player2_start_location)
	
	boat_movement_timer = 0
	countdown_timer = 0
	countdown_text.set_text("Get Ready!")
	countdown_text.show()
	state = State.COUNTDOWN
	
	boat_node.set_pos(Vector2(0, 0))
	update_platform_speed(INITIAL_PLATFORM_SPEED)

func _process(delta):
	if state == State.COUNTDOWN:
		countdown_timer += delta
		var remaining = 3 - (floor(countdown_timer))
		if (remaining == 0):
			remaining = "GO!"
		
		if (countdown_timer >= 4):
			countdown_text.hide()
			state = State.PLAYING
			platform_manager.set_process(true)
			
		countdown_text.set_text(String(remaining))
		return
	
	update_boat(delta)

func update_platform_speed(speed):
	platform_manager.set_speed(speed)
	player1.set_platform_speed(speed)
	player2.set_platform_speed(speed)

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
	boat_pos.y += platform_manager.get_speed() * delta
	boat_node.set_pos(boat_pos)