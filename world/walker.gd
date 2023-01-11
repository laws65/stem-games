extends Node
class_name Walker

const directions = [Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.LEFT]
var position := Vector2.ZERO
var direction := Vector2.RIGHT
var borders := Rect2()
var step_history := []
var steps_since_turn := 0
var rooms := []

func _init(starting_pos, new_borders):
	assert(new_borders.has_point(starting_pos))
	position = starting_pos
	step_history.append(position)
	borders = new_borders
	
func walk(steps):
	place_room(position)
	for step in steps:
		if steps_since_turn >= 8:
			change_direction()
		if step():
			step_history.append(position)
		else:
			change_direction()
	place_room(position)
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():
	place_room(position)
	steps_since_turn = 0
	var _directions = directions.duplicate()
	_directions.erase(direction)
	_directions.shuffle()
	direction = _directions.pop_front()
	while not borders.has_point(position + direction):
		direction = _directions.pop_front()

func create_room(pos, size):
	return {pos = pos, size = size}

func place_room(position):
	var size = Vector2(randi() % 4 + 3, randi() % 4 + 3)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x,y)
			if borders.has_point(new_step):
				step_history.append(new_step)

func get_furthest_room(pos):
	var end_room = rooms[0]
	for room in rooms:
		if pos.distance_to(room.pos)>pos.distance_to(end_room.pos):
			end_room = room
	return end_room	

