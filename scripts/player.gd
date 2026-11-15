extends CharacterBody2D

var speed = 300
var ammo = 10
var health = 100
var dead = false
var fire_delay = 0.2
var fire_wait = 0.0

var sheets = {
	"idle": preload("res://characters/thug/Idle.png"),
	"run": preload("res://characters/thug/Run.png"),
	"shoot": preload("res://characters/thug/Attack1.png"),
	"run_shoot": preload("res://characters/thug/RunAttack.png"),
	"die": preload("res://characters/thug/Die.png"),
}
var anim = "idle"
var anim_time = 0.0
var row = 0

var bullet_scene = preload("res://scenes/bullet.tscn")
var island = null

@onready var sprite = $Sprite2D

func _ready():
	island = get_tree().get_first_node_in_group("island")

func _physics_process(delta):
	anim_time += delta * 10.0
	if dead:
		sprite.frame = row * 8 + min(int(anim_time), 7)
		return

	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var current_speed = speed
	if island != null and island.in_water(global_position):
		current_speed *= 0.6
	velocity = dir * current_speed
	move_and_slide()

	var aim = (get_global_mouse_position() - chest()).angle()
	row = posmod(int(round(aim / (PI / 4.0))), 8)

	var firing = Input.is_action_pressed("shoot") and ammo > 0
	fire_wait -= delta
	if firing and fire_wait <= 0:
		shoot()
		fire_wait = fire_delay

	var moving = dir != Vector2.ZERO
	if moving and firing:
		play("run_shoot")
	elif moving:
		play("run")
	elif firing:
		play("shoot")
	else:
		play("idle")
	sprite.frame = row * 8 + int(anim_time) % 8

func play(new_anim):
	if anim == new_anim:
		return
	anim = new_anim
	sprite.texture = sheets[new_anim]

func chest():
	return global_position + Vector2(0, -50)

func shoot():
	ammo -= 1
	var b = bullet_scene.instantiate()
	b.direction = (get_global_mouse_position() - chest()).normalized()
	b.global_position = chest() + b.direction * 30
	get_parent().add_child(b)

func take_damage(amount):
	if dead:
		return
	health -= amount
	if health <= 0:
		health = 0
		dead = true
		play("die")
		anim_time = 0.0

func revive():
	dead = false
	health = 50
	play("idle")
	for z in get_tree().get_nodes_in_group("zombies"):
		if z.global_position.distance_to(global_position) < 400:
			z.die()
