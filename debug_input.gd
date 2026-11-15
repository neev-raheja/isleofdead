extends Node

var timer = 0.0

func _ready():
	print("DEBUG start. actions: ", InputMap.has_action("move_left"), InputMap.has_action("move_right"), InputMap.has_action("move_up"), InputMap.has_action("move_down"), InputMap.has_action("shoot"))
	for a in ["move_left", "move_right", "move_up", "move_down", "shoot"]:
		var texts = []
		for e in InputMap.action_get_events(a):
			texts.append(e.as_text())
		print("DEBUG action ", a, " = ", texts)

func _input(event):
	if event is InputEventKey:
		print("DEBUG key ", event.as_text(), " pressed=", event.pressed, " echo=", event.echo, " physical=", event.physical_keycode, " keycode=", event.keycode, " device=", event.device)
	if event is InputEventMouseButton:
		print("DEBUG mouse button ", event.button_index, " pressed=", event.pressed)

func _process(delta):
	timer -= delta
	if timer <= 0:
		timer = 1.0
		var p = get_tree().get_first_node_in_group("player")
		print("DEBUG tick focus=", DisplayServer.window_is_focused(), " paused=", get_tree().paused, " time_scale=", Engine.time_scale, " vector=", Input.get_vector("move_left", "move_right", "move_up", "move_down"), " player=", p.global_position.round(), " dead=", p.dead, " velocity=", p.velocity.round(), " physics=", p.is_physics_processing())
