extends CanvasLayer

var player = null

@onready var info = $Info
@onready var game_over = $GameOver
@onready var waves = $"../Waves"
@onready var revive = $"../Revive"

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	info.text = "Health: %d   Ammo: %d   Wave: %d   Zombies: %d" % [
		player.health, player.ammo, waves.wave, waves.zombies_alive()]

	if revive.failed:
		game_over.text = "GAME OVER\nYou reached wave %d\nPress R to try again" % waves.wave
	elif waves.won:
		game_over.text = "SUNRISE! YOU SURVIVED\nPress R to play again"
	game_over.visible = revive.failed or waves.won

	if game_over.visible and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
