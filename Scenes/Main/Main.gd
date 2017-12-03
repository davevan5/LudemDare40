extends Node2D

enum State {
	COUNTDOWN,
	PLAYING,
	END
}

const BOAT_WAIT_TIME = 7
const INITIAL_PLATFORM_SPEED = 100
const INTIAL_GAME_SPEED = 1.0
const GAME_ACCELERATION_RATE = 0.00000005
const WIN_SCORE = 10

var state = State.COUNTDOWN

var countdown_timer = 0.0
var countdown_images

var boat_movement_timer = 0.0
var game_time = 0.0
var game_speed = INTIAL_GAME_SPEED
var game_acceleration = 1.0

var player1
var player2
var player1_start_location
var player2_start_location

var player1_score = 0
var player2_score = 0

var player1_score_text
var player2_score_text

var player1_win_display
var player2_win_display

var countdown_text
var boat_node
var platform_manager

func _init():
	Globals.set("game_speed", INTIAL_GAME_SPEED)

func _ready():
	countdown_images = [
		get_node("3"),
		get_node("2"),
		get_node("1"),
		get_node("go")
	]
	
	for image in countdown_images:
		image.hide()
	
	get_node("SamplePlayer").play("music")
	platform_manager = get_node("PlatformManager")

	player1 = get_node("Player1")
	player2 = get_node("Player2")
	player1_start_location = player1.get_pos()
	player2_start_location = player2.get_pos()
	player1.connect("player_died", self, "on_player1_died")
	player2.connect("player_died", self, "on_player2_died")
	
	player1_score_text = get_node("Player1Score/Text")
	player2_score_text = get_node("Player2Score/Text")
	
	player1_win_display = get_node("red wins")
	player2_win_display = get_node("blue wins")
	
	boat_node = get_node("BoatContainer/Boat")
	reset_game()
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed("retry") && state == State.END:
		reset_game()

func on_player1_died():
	on_player2_win()

func on_player2_died():
	on_player1_win()
	
func reset_game():
	player1.set_pos(player1_start_location)
	player2.set_pos(player2_start_location)
	player1.set_linear_velocity(Vector2(0, 0))
	player2.set_linear_velocity(Vector2(0, 0))
	
	game_time = 0.0
	game_speed = INTIAL_GAME_SPEED
	game_acceleration = 1.0
	boat_movement_timer = 0
	countdown_timer = 0
	state = State.COUNTDOWN
	
	player1_score = 0
	player2_score = 0
	player1_score_text.set_bbcode("[center]0[/center]")
	player2_score_text.set_bbcode("[center]0[/center]")
	
	player1_win_display.hide()
	player2_win_display.hide()
	
	boat_node.set_pos(Vector2(0, 0))
	update_platform_speed(INITIAL_PLATFORM_SPEED)
	resume()
	
	platform_manager.set_process(false)
	platform_manager.reset()

func _process(delta):
	if state == State.END:
		return
	
	game_time += delta
	game_speed *= game_acceleration
	Globals.set("game_speed", game_speed)
	game_acceleration += GAME_ACCELERATION_RATE
	update_platform_speed(INITIAL_PLATFORM_SPEED * game_speed)
	
	if state == State.COUNTDOWN:
		countdown_timer += delta
		var image_index = floor(countdown_timer)
		show_countdown(image_index)

		if (countdown_timer >= 4):
			hide_countdown()
			state = State.PLAYING
			platform_manager.set_process(true)
			
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
	
func on_coin_collected(by):
	if by == player1:
		player1_score += 1
		player1_score_text.set_bbcode("[center]" + String(player1_score) + "[/center]")
		
	if by == player2:
		player2_score += 1
		player2_score_text.set_bbcode("[center]" + String(player2_score) + "[/center]")
		
	if player1_score > WIN_SCORE:
		on_player1_win()
		
	if player2_score > WIN_SCORE:
		on_player2_win()

func pause():
	player1.set_process(false)
	player1.set_fixed_process(false)
	player2.set_process(false)
	player2.set_fixed_process(false)
	platform_manager.set_process(false)
	
	for child in platform_manager.get_children():
		child.set_process(false)
		child.set_fixed_process(false)
	
func resume():
	player1.set_process(true)
	player1.set_fixed_process(true)
	player2.set_process(true)
	player2.set_fixed_process(true)
	platform_manager.set_process(true)
	
	for child in platform_manager.get_children():
		child.set_process(true)
		child.set_fixed_process(true)
	
func on_player1_win():
	pause()
	state = State.END
	player1.arms_up()
	player1_win_display.show()

func on_player2_win():
	pause()
	state = State.END
	player2.arms_up()
	player2_win_display.show()
	
func show_countdown(index):
	for i in range(4):
		if i == index:
			countdown_images[i].show()
		else:
			countdown_images[i].hide()

func hide_countdown():
	for image in countdown_images:
		image.hide()