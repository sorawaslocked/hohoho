extends CharacterBody2D

const FRICTION = 1000

@onready var path_follow_2d = get_parent()
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_detection = $FloorDetection
@onready var player_detection = $PlayerDetection
@onready var default_snowman = $"."
@onready var player = $"../Player"

var direction = 1
var speed = 150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	apply_gravity(delta)
	if player_detection.is_colliding():
		follow_player(delta)
	else:
		speed = 150
		handle_movement()
	move_and_slide()

func follow_player(delta):
	speed = 250
	if global_position.distance_to(player.global_position) < 75:
		velocity.x = 0
	else:
		handle_movement()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func flip():
	direction *= -1
	scale.x *= -1

func handle_movement():
	if not floor_detection.is_colliding():
		flip()
	
	velocity.x = speed * direction
