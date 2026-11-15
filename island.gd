extends TileMapLayer

var width = 64
var height = 44

var ponds = [
	[Vector2i(16, 32), Vector2i(10, 7)],
	[Vector2i(4, 3), Vector2i(9, 8)],
	[Vector2i(39, 2), Vector2i(6, 6)],
	[Vector2i(50, 3), Vector2i(10, 8)],
	[Vector2i(35, 33), Vector2i(11, 8)],
]

func _ready():
	add_to_group("island")
	paint_island()
	for pond in ponds:
		paint_pond(pond[0], pond[1])
	build_walls()

func paint_island():
	for x in width:
		for y in height + 3:
			set_cell(Vector2i(x, y), 0, Vector2i(sheet_column(x), sheet_row(y)))

func sheet_column(x):
	if x < 2:
		return x
	if x >= width - 2:
		return 6 - (width - 1 - x)
	return 2 + (x - 2) % 3

func sheet_row(y):
	if y < 2:
		return y
	if y >= height - 1:
		return 5 + (y - (height - 1))
	return 2 + (y - 2) % 3

func paint_pond(corner, size):
	for x in size.x:
		for y in size.y:
			if (x == 0 or x == size.x - 1) and (y == 0 or y == size.y - 1):
				continue
			var column = 3 + x % 2
			if x < 3:
				column = 1 + x
			elif x >= size.x - 3:
				column = 6 - (size.x - 1 - x)
			var row = 11 + y % 2
			if y < 3:
				row = 9 + y
			elif y >= size.y - 3:
				row = 14 - (size.y - 1 - y)
			set_cell(corner + Vector2i(x, y), 0, Vector2i(column, row))

func in_water(spot):
	for pond in ponds:
		var middle = (Vector2(pond[0]) + Vector2(pond[1]) / 2.0) * 96.0
		var reach = (Vector2(pond[1]) - Vector2(1.7, 1.7)) / 2.0 * 96.0
		if ((spot - middle) / reach).length() < 1.0:
			return true
	return false

func build_walls():
	var w = width * 32.0
	var h = height * 32.0
	add_wall(Rect2(-84, -100, 100, h + 200))
	add_wall(Rect2(w - 16, -100, 100, h + 200))
	add_wall(Rect2(0, -88, w, 100))
	add_wall(Rect2(0, h + 4, w, 100))

func add_wall(rect):
	var shape = RectangleShape2D.new()
	shape.size = rect.size
	var col = CollisionShape2D.new()
	col.shape = shape
	var body = StaticBody2D.new()
	body.position = rect.position + rect.size / 2
	body.add_child(col)
	add_child(body)
