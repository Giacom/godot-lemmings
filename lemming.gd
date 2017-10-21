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

	var floor_collision = world.check_collisions(Rect2(position + Vector2(0, 1), sprite_size))
	if floor_collision == false:
		proposed_movement = position + Vector2(0, 1)
	else:
		var resolved = -1
		for i in range(floor(sprite_size.y / 2)):
			var test_movement = Rect2(proposed_movement - Vector2(0, i), sprite_size)
			if not world.is_in_world(test_movement.position.x, test_movement.position.y):
				break
			var proposed_collision = world.check_collisions(test_movement)
			if proposed_collision == false:
				resolved = i
				break

		if resolved >= 0:
			proposed_movement -= Vector2(0, resolved)
		else:
			moving = Movement.Left if moving == Movement.Right else Movement.Right
			mov_modifier = get_movement_modifier()
			proposed_movement = position + Vector2(mov_modifier * 1, 0)

	flip_h = true if moving == Movement.Left else false
	self.position = proposed_movement

