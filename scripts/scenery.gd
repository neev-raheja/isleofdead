extends Node2D

var tree_1 = preload("res://world_build/Tree_01.png")
var tree_2 = preload("res://world_build/Tree_02.png")
var tree_3 = preload("res://world_build/Tree_03.png")
var props = preload("res://world_build/Props_Forest.png")
var ruin_sheet = preload("res://world_build/Structure_White.png")

var ruins = [Vector2(768, 2832), Vector2(2112, 816), Vector2(3936, 1488), Vector2(5280, 2928)]
var taken = []

@onready var island = $"../Island"

func _ready():
	seed(7)
	for spot in ruins:
		add_ruin(spot)

	var kinds = [
		[tree_1, Rect2(160, 106, 120, 166), 50, 22],
		[tree_2, Rect2(172, 97, 104, 175), 50, 20],
		[tree_3, Rect2(172, 96, 98, 176), 50, 20],
		[tree_1, Rect2(288, 224, 59, 94), 30, 26],
		[tree_3, Rect2(292, 192, 59, 96), 30, 24],
		[tree_1, Rect2(57, 280, 43, 40), 90, 12],
		[tree_1, Rect2(295, 705, 44, 93), 30, 14],
		[props, Rect2(1, 583, 63, 46), 150, 12],
		[props, Rect2(1, 680, 63, 45), 150, 8],
		[props, Rect2(0, 128, 32, 32), 0, 30],
		[props, Rect2(32, 128, 32, 32), 0, 30],
	]
	for kind in kinds:
		for i in kind[3]:
			var spot = find_spot()
			if spot != null:
				add_prop(kind[0], kind[1], spot, kind[2])

	for i in 150:
		var spot = find_spot()
		if spot != null:
			add_flat(props, Rect2(32 * randi_range(0, 5), 32 * randi_range(0, 3), 32, 32), spot)
	randomize()

func find_spot():
	var w = island.width * 96.0
	var h = island.height * 96.0
	for attempt in 30:
		var spot = Vector2(randf_range(150, w - 150), randf_range(400, h - 150))
		var ok = true
		if island.in_water(spot):
			ok = false
		if spot.distance_to(Vector2(w / 2, h / 2)) < 350:
			ok = false
		for ruin in ruins:
			if spot.distance_to(ruin) < 420:
				ok = false
		for other in taken:
			if spot.distance_to(other) < 180:
				ok = false
		if ok:
			taken.append(spot)
			return spot
	return null

func add_prop(sheet, region, spot, solid_width):
	var body = StaticBody2D.new()
	body.position = spot
	add_child(body)

	var sprite = Sprite2D.new()
	sprite.texture = sheet
	sprite.region_enabled = true
	sprite.region_rect = region
	sprite.scale = Vector2(3, 3)
	sprite.offset = Vector2(0, -region.size.y / 2)
	body.add_child(sprite)

	if solid_width > 0:
		var shape = RectangleShape2D.new()
		shape.size = Vector2(solid_width, 30)
		var col = CollisionShape2D.new()
		col.shape = shape
		col.position = Vector2(0, -15)
		body.add_child(col)

func add_flat(sheet, region, spot):
	var sprite = Sprite2D.new()
	sprite.texture = sheet
	sprite.region_enabled = true
	sprite.region_rect = region
	sprite.scale = Vector2(3, 3)
	sprite.position = spot
	sprite.z_index = -1
	add_child(sprite)

func add_ruin(spot):
	add_flat(ruin_sheet, Rect2(16, 792, 153, 164), spot)
	var shape = RectangleShape2D.new()
	shape.size = Vector2(430, 480)
	var col = CollisionShape2D.new()
	col.shape = shape
	var body = StaticBody2D.new()
	body.position = spot
	body.add_child(col)
	add_child(body)
