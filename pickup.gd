extends Area2D

var life = 25.0
var bob = 0.0

@onready var sprite = $Sprite2D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	bob += delta * 4.0
	sprite.position.y = -36 + sin(bob) * 5.0
	life -= delta
	if life < 5.0:
		sprite.visible = int(life * 6.0) % 2 == 0
	if life <= 0:
		queue_free()

func _on_body_entered(body):
	if body.has_method("drink"):
		body.drink()
		queue_free()
