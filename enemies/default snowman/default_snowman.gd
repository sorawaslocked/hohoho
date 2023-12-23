extends CharacterBody2D

const FRICTION = 1000

@onready var path_follow_2d = get_parent()
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_detection = $FloorDetection
@onready var player_detection = $PlayerDetection
@onready var default_snowman = $"."
@onready var player = $"../Player"
@onready var attack_cooldown = $AttackCooldown
@onready var wall_detection = $WallDetection

var direction = 1
var speed = 150
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_do_damage = false
var HP = 120

func _ready():
	pass

func _process(delta):
	apply_gravity(delta)
	if not player_detection.get_collider() is StaticBody2D \
	and player_detection.get_collider() != null:
		follow_player()
	else:
		speed = 150
		handle_movement()
	if wall_detection.is_colliding():
		flip()
	move_and_slide()
	if HP <= 0:
		queue_free()
	
func attack():
	attack_cooldown.start()
	if can_do_damage:
		player.HP -= 40

func follow_player():
	speed = 250
	if player != null and global_position.distance_to(player.global_position) < 75:
		velocity.x = 0
		if attack_cooldown.time_left == 0.0:
			attack()
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

func _on_hit_area_body_entered(body):
	can_do_damage = true

func _on_hit_area_body_exited(body):
	can_do_damage = false
