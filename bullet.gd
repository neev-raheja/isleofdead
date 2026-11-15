extends Area2D

var speed = 1100
var direction = Vector2.RIGHT
var life = 1.5

func _ready():
	rotation = direction.angle()
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta
	life -= delta
	if life <= 0:
		queue_free()

func _on_area_entered(area):
	var zombie = area.get_parent()
	if zombie.has_method("hit"):
		zombie.hit()
		queue_free()

func _on_body_entered(_body):
	queue_free()
