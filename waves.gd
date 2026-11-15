extends Node

var zombie_scene = preload("res://zombie.tscn")

var wave = 0
var last_wave = 10
var next_wave_in = 3.0
var won = false
var player = null

@onready var island = $"../Island"
@onready var night = $"../Night"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.global_position = Vector2(island.width, island.height) * 48.0

func _process(delta):
	if won or player.dead:
		return

	if zombies_alive() == 0 and wave == last_wave:
		won = true
		night.color = Color.WHITE
		return

	if zombies_alive() == 0 and wave > 0 and next_wave_in > 3.0:
		next_wave_in = 3.0

	next_wave_in -= delta
	if next_wave_in <= 0 and wave < last_wave:
		start_wave()

func start_wave():
	wave += 1
	next_wave_in = 30.0
	var count = 4 + wave * 2
	var hits = 0
	for i in count:
		var kind = "walker"
		var kind_health = 3
		if wave >= 3 and i % 4 == 3:
			kind = "runner"
			kind_health = 2
		if wave % 3 == 0 and i * 3 < wave:
			kind = "brute"
			kind_health = 12
		hits += kind_health
		spawn_zombie(kind)
	player.ammo += int(hits * 1.275)

func spawn_zombie(kind):
	var spot = player.global_position
	for attempt in 10:
		spot = player.global_position + Vector2(900, 0).rotated(randf() * TAU)
		spot.x = clamp(spot.x, 150, island.width * 96 - 150)
		spot.y = clamp(spot.y, 150, island.height * 96 - 150)
		if spot.distance_to(player.global_position) > 600:
			break
	var z = zombie_scene.instantiate()
	z.kind = kind
	z.extra_speed = wave * 5
	z.position = spot
	get_parent().add_child(z)

func zombies_alive():
	return get_tree().get_nodes_in_group("zombies").size()
