extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const ACCELERATION = 1000
const FRICTION = 2000	
@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	apply_gravity(delta)
	handle_jump()
	handle_movement(direction, delta)
	apply_animations(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_floor:
		coyote_jump_timer.start()

func handle_movement(direction, delta):
	if direction:
		velocity.x = SPEED * direction
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2 and not is_on_floor():
			velocity.y = JUMP_VELOCITY / 2

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func apply_animations(direction):
	if direction:
		animated_sprite.play("walk")
		if direction > 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
