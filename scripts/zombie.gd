extends CharacterBody2D

var kind = "walker"
var extra_speed = 0
var speed = 110
var health = 3
var damage = 10
var size = 1.0

var attack_wait = 0.0
var attack_time = 0.0
var sidestep_time = 0.0
var side = 1
var dying = false
var corpse_time = 0.0

var walk_sheet = preload("res://characters/thug/Walk.png")
var run_sheet = preload("res://characters/thug/Run.png")
var attack_sheet = preload("res://characters/thug/Attack2.png")
var die_sheet = preload("res://characters/thug/Die.png")
var move_sheet = walk_sheet
var anim_time = 0.0
var row = 2

var player = null
var island = null

@onready var sprite = $Sprite2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	island = get_tree().get_first_node_in_group("island")
	if randf() < 0.5:
		side = -1

	if kind == "runner":
		speed = 210
		health = 2
		damage = 8
		size = 0.9
		move_sheet = run_sheet
		sprite.modulate = Color(1.2, 1.3, 0.5)
	elif kind == "brute":
		speed = 75
		health = 12
		damage = 25
		size = 1.5
		sprite.modulate = Color(0.7, 1.0, 1.3)
	speed += extra_speed

	sprite.texture = move_sheet
	sprite.scale = Vector2(4, 4) * size
	sprite.position = Vector2(0, -60) * size
	$Hurtbox.scale = Vector2(size, size)

func _physics_process(delta):
	anim_time += delta * 10.0

	if dying:
		sprite.frame = row * 8 + min(int(anim_time), 7)
		corpse_time += delta
		if corpse_time > 6.0:
			queue_free()
		return

	if player.dead:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()
	attack_wait -= delta

	if attack_time > 0:
		attack_time -= delta
		sprite.frame = row * 8 + min(int(anim_time), 7)
		if attack_time <= 0:
			sprite.texture = move_sheet
		return

	if distance < 60 * size and attack_wait <= 0:
		player.take_damage(damage)
		attack_wait = 0.9
		attack_time = 0.6
		anim_time = 0.0
		sprite.texture = attack_sheet
		row = facing_row(to_player)
		return

	var dir = to_player.normalized()
	if sidestep_time > 0:
		sidestep_time -= delta
		dir = dir.rotated(1.3 * side)

	for other in get_tree().get_nodes_in_group("zombies"):
		if other != self:
			var away = global_position - other.global_position
			var gap = away.length()
			if gap < 40 and gap > 0.01:
				dir += away / gap * (1.0 - gap / 40.0)
	dir = dir.normalized()

	var current_speed = speed
	if island.in_water(global_position):
		current_speed = speed * 0.6
	if distance < 52 * size:
		current_speed = 0
	velocity = dir * current_speed
	move_and_slide()

	if current_speed > 0 and get_real_velocity().length() < current_speed * 0.3:
		sidestep_time = 0.6

	row = facing_row(dir)
	sprite.frame = row * 8 + int(anim_time) % 8

func facing_row(direction):
	return posmod(int(round(direction.angle() / (PI / 4.0))), 8)

func hit():
	if dying:
		return
	health -= 1
	if health <= 0:
		die()

func die():
	if dying:
		return
	dying = true
	anim_time = 0.0
	sprite.texture = die_sheet
	remove_from_group("zombies")
	$CollisionShape2D.set_deferred("disabled", true)
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	z_index = -1
