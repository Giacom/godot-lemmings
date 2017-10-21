extends Sprite

class Pixel:
	var is_empty = false

	func _init(var empty):
		self.is_empty = empty

var world_pixels = []
var world_size

var update_map = false

func _ready():
	var image = texture.get_data()
	var size = image.get_size()
	
	world_size = size
	print(world_size)
	
	image.lock()
	for y in range(size.y):
		for x in range(size.x):
			var color = image.get_pixel(x, y)
			world_pixels.push_back(Pixel.new(color.a == 0))

	image.unlock()
	
	texture = ImageTexture.new()
	texture.create_from_image(image, 0)

	
	get_node("/root/game").set_world(self)
	
func _process(delta):
	if update_map:
		var image = texture.get_data()
		image.lock()
		for y in range(world_size.y):
			for x in range(world_size.x):
				var pixel = get_data(x, y)
				if pixel.is_empty:
					image.set_pixel(x, y, Color(0, 0, 0, 0))
		texture.set_data(image)
		image.unlock()
		update_map = false
	
func _input(var event):
	make_input_local(event)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var blast = Vector2(8, 8)
			destroy_world(Rect2(get_local_mouse_position() - blast, blast * 2))
	
func get_data(var x, var y):
	#return world_pixels[y][x]
	var index = int((int(y) * int(world_size.x)) + int(x))
	return world_pixels[index]
	
func is_in_world(var x, var y):
	return x >= 0 and y >= 0 and x < world_size.x and y < world_size.y
	
func check_collision_on_point(var x, var y):
	if x != int(x) or y != int(y):
		print("Error. Non-rounded X/Y value. X: %d, Y: %d" % [x, y])
	if is_in_world(x, y):
		var pixel = get_data(x, y)
		return !pixel.is_empty
#	else:
#		print("Error checking collision. X: %d, Y: %d" % [x, y])
	return false
	
func check_collisions(var rect):
	for x_offset in range(rect.position.x, rect.end.x):
		for y_offset in range(rect.position.y, rect.end.y):
			if check_collision_on_point(x_offset, y_offset):
				return true
	return false
	
func destroy_world(var rect):
	var round_rect = Rect2(int(rect.position.x), int(rect.position.y), int(rect.size.x), int(rect.size.y))
	print(round_rect)
	for y in range(round_rect.position.y, round_rect.end.y):
		for x in range(round_rect.position.x, round_rect.end.x):
			if is_in_world(x, y):
				get_data(x, y).is_empty = true
	update_map = true