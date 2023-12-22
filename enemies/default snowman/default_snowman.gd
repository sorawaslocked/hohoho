extends CharacterBody2D

const SPEED = 200

@onready var path_follow_2d = get_parent()
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = $"../../../../Player"
@onready var default_snowman = $"."

var move_right = true
var is_aggroed = false
var direction = 0

func _ready():
	pass

func _process(delta):
	if not is_aggroed:
		patrol(delta)
	else:
		if player.global_position.x < default_snowman.global_position.x - 1:
			direction = -1
		elif player.global_position.x > default_snowman.global_position.x + 1:
			direction = 1
		else:
			direction = 0
		follow_player(delta)


func patrol(delta):
	if move_right:
		if path_follow_2d.progress_ratio == 1.0:
			scale.x *= -1
			move_right = false
		else:
			path_follow_2d.progress += SPEED * delta
	else:
		if path_follow_2d.progress_ratio == 0.0:
			scale.x *= -1
			move_right = true
		else:
			path_follow_2d.progress -= SPEED * delta

func follow_player(delta):
	if direction:
		velocity.x = SPEED * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

func _on_area_2d_body_entered(body):
	is_aggroed = true

func _on_area_2d_body_exited(body):
	is_aggroed = false
