extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const ACCELERATION = 1000
const FRICTION = 2000	
@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var default_snowman = $"../DefaultSnowman"
@onready var attack_cooldown = $AttackCooldown

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var HP = 200
var can_do_damage = false
var enemies = []

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	apply_gravity(delta)
	handle_jump()
	handle_movement(direction, delta)
	apply_animations(direction)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_floor = was_on_floor and not is_on_floor() and velocity.y >= 0
	if attack_cooldown.time_left == 0.0 and Input.is_action_just_pressed("attack"):
		attack()
	if just_left_floor:
		coyote_jump_timer.start()
	if HP <= 0:
		queue_free()
		
func attack():
	attack_cooldown.start()
	if can_do_damage:
		for enemy in enemies:
			enemy.HP -= 40
			print(enemy.HP)

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


func _on_hit_area_body_entered(body):
	can_do_damage = true
	enemies.append(body)

func _on_hit_area_body_exited(body):
	can_do_damage = false
	enemies.erase(body)
