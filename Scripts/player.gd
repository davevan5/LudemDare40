extends RigidBody2D

enum States {
	GROUND,
	JUMPING,
	FALLING
}

enum LookDirection {
	LEFT,
	RIGHT
}

const UP = Vector2(0.0, -1.0)
const RIGHT = Vector2(1.0, 0.0)
const LEFT = Vector2(-1.0, 0.0)

var look_direction = LookDirection.RIGHT
var state = States.GROUND
var action_move_left = "player1_move_left"
var action_move_right = "player1_move_right"
var action_jump = "player1_jump"

var jump_impulse = 0
const jump_impulse_initial = 25000
const jump_impulse_decay = 23000

const ground_acceleration = 2000;
const air_acceleration = 1000;

const max_horizontal_speed = 300;

var left_floor_raycast
var right_floor_raycast
var animation_player

func _ready():
	animation_player = get_node("Player1Sprite/animation")
	setup_raycasts()
	set_fixed_process(true)
	
func setup_raycasts():
	left_floor_raycast = get_node("LeftFloorRaycast")
	left_floor_raycast.add_exception(self)
	right_floor_raycast = get_node("RightFloorRaycast")
	right_floor_raycast.add_exception(self)

func is_on_ground():
	return left_floor_raycast.is_colliding() || right_floor_raycast.is_colliding()

func calculate_horizontal_velocity_adjustment(delta, acceleration):
	var result = Vector2(0, 0)

	if Input.is_action_pressed(action_move_right):
		result += RIGHT * acceleration * delta
		
	if Input.is_action_pressed(action_move_left):
		result += LEFT * acceleration * delta
		
	return result

func _fixed_process(delta):
	var velocity = get_linear_velocity()
	
	if state == States.GROUND:
		if Input.is_action_pressed(action_jump):
			state = States.JUMPING
			jump_impulse = jump_impulse_initial
		
		velocity += calculate_horizontal_velocity_adjustment(delta, ground_acceleration)
			
		if !is_on_ground():
			state = States.FALLING

	if state == States.JUMPING:
		jump_impulse -= jump_impulse_decay * delta
		# If we run out of jump then that means we must begin falling
		if jump_impulse < 0 || !Input.is_action_pressed(action_jump):
			jump_impulse = 0
			state = States.FALLING
		else:
			velocity.y = -jump_impulse * delta
		
		velocity += calculate_horizontal_velocity_adjustment(delta, air_acceleration)
	
	if state == States.FALLING:
		if is_on_ground():
			state = States.GROUND
		
		velocity += calculate_horizontal_velocity_adjustment(delta, air_acceleration)
	
	# cap horizontal velocity
	if velocity.x > max_horizontal_speed:
		velocity.x = max_horizontal_speed
	
	if velocity.x < -max_horizontal_speed:
		velocity.x = -max_horizontal_speed
	
	set_linear_velocity(velocity)
	
	# Set player direction based velocity
	if velocity.x < 0:
		look_direction = LookDirection.LEFT
	elif velocity.x > 0:
		look_direction = LookDirection.RIGHT
	
	# Set animation based off velocity
	if velocity.x != 0:
		if look_direction == LookDirection.LEFT:
			play_animation("WalkLeft")
		else:
			play_animation("WalkRight")
	else:
		if look_direction == LookDirection.LEFT:
			play_animation("IdleLeft")
		else:
			play_animation("IdleRight")

func play_animation(animation_name):
	if !animation_player.is_playing() || animation_player.get_current_animation() != animation_name:
		animation_player.play(animation_name)
