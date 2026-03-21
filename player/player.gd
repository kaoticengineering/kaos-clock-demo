extends CharacterBody2D

# Movement
const SPEED = 100.0
const SPRINT_MULTIPLIER = 2.0
const JUMP_VELOCITY = -275.0

# For Character Animation State Tracking
var animation_state = "idle"
@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Normal Movement
	var input_dir = Input.get_axis("move_left", "move_right")
	var current_speed = SPEED

	# If Sprinting
	if Input.is_action_pressed("sprint"):
		current_speed *= SPRINT_MULTIPLIER

	# Horizontal Movement
	if input_dir != 0.0:
		velocity.x = input_dir * current_speed
		animated_sprite.flip_h = input_dir < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Setting the Animation State
	_update_animation_state()
	_play_animation_if_changed()
	move_and_slide()


# Decide which Animation State to be in
func _update_animation_state() -> void:
	if not is_on_floor():
		animation_state = "jump"
	elif abs(velocity.x) > 5.0:
		animation_state = "run"
	else:
		animation_state = "idle"


# Checks the actual animation state against the state we think we should be in
# If those don't agree, switch to the one we think we should be in
func _play_animation_if_changed() -> void:
	if animated_sprite.animation != animation_state:
		animated_sprite.play(animation_state)
