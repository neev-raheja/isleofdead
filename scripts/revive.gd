extends CanvasLayer

var playing = false
var failed = false
var hits = 0
var revives = 0
var speed = 400.0
var direction = 1
var wait = 0.0
var player = null

@onready var green = $Box/Green
@onready var slider = $Box/Slider
@onready var label = $Box/Label

func _ready():
	player = get_tree().get_first_node_in_group("player")
	visible = false

func _process(delta):
	if failed:
		return

	if not playing:
		if player.dead:
			start()
		return

	slider.position.x += speed * direction * delta
	if slider.position.x > 290:
		direction = -1
	if slider.position.x < -300:
		direction = 1

	wait -= delta
	if wait <= 0 and Input.is_action_just_pressed("shoot"):
		var middle = slider.position.x + 5
		if middle >= green.position.x and middle <= green.position.x + green.size.x:
			hits += 1
			speed *= 1.4
			move_green()
			if hits == 3:
				playing = false
				visible = false
				revives += 1
				player.revive()
		else:
			playing = false
			failed = true
			visible = false

func start():
	playing = true
	visible = true
	hits = 0
	speed = 400.0 + revives * 120.0
	wait = 0.8
	slider.position.x = -300
	move_green()

func move_green():
	green.position.x = randf_range(-300, 300 - green.size.x)
	label.text = "Tap when the slider is on green   %d / 3" % hits
