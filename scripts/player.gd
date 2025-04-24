extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const ROLL_SPEED = 200.0
const ROLL_DURATION = 0.7  # matches 7 frames at 10fps

var is_rolling = false
var roll_timer = 0.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle roll timer
	if is_rolling:
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false

	# Handle roll input
	if Input.is_action_just_pressed("roll") and not is_rolling and is_on_floor():
		is_rolling = true
		roll_timer = ROLL_DURATION
		$AnimatedSprite2D.play("roll")

	# Jump (only when not rolling)
	if not is_rolling and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * (ROLL_SPEED if is_rolling else SPEED)
		$AnimatedSprite2D.flip_h = direction < 0
	else:
		if not is_rolling:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animation logic
	if not is_rolling and is_on_floor():
		$AnimatedSprite2D.play("idle")

	move_and_slide()
