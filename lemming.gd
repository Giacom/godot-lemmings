extends Sprite

enum Movement {
	Right,
	Left
}

var moving = Movement.Right
var world_pos = Vector2()

onready var world = get_parent()
onready var sprite_size = get_region_rect().size

func get_movement_modifier():
	return 1 if moving == Movement.Right else -1

func process_lemming():
	var mov_modifier = get_movement_modifier()
	var proposed_movement = position + Vector2(mov_modifier * 1, 0)

	var floor_collision = world.check_collisions(Rect2(position + Vector2(0, sprite_size.y), Vector2(sprite_size.x, 1)))
	if floor_collision == false:
		proposed_movement = position + Vector2(0, 1)
	else:
		var resolved = -1
		for y in range(3):
			var test_movement
			if moving == Movement.Left:
				test_movement = Rect2(proposed_movement + Vector2(0, -y), Vector2(1, sprite_size.y))
			else:
				test_movement = Rect2(proposed_movement + Vector2(sprite_size.x - 1, -y), Vector2(1, sprite_size.y))
			if not world.is_in_world(test_movement.position.x, test_movement.position.y):
				break
			var collided = world.check_collisions(test_movement)
			if collided == false:
				resolved = y
				break

		if resolved >= 0:
			proposed_movement -= Vector2(0, resolved)
		else:
			moving = Movement.Left if moving == Movement.Right else Movement.Right
			mov_modifier = get_movement_modifier()
			proposed_movement = position + Vector2(mov_modifier * 1, 0)

	flip_h = true if moving == Movement.Left else false
	self.position = proposed_movement

