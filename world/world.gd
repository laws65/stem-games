extends Node2D

var borders := Rect2()

export(NodePath) var tilemapPath
onready var tilemap = get_node(tilemapPath)
export(NodePath) var playerPath
onready var player = get_node(playerPath)
onready var exit = preload("res://world/exit_door.tscn")


func _ready():
	borders = Rect2(Vector2(1,1), (get_viewport_rect().size/32).round()-Vector2(2,2))
	generate_level()
	
func generate_level():
	randomize()
	
	var walker = Walker.new((borders.size/2).round(), borders)
	var map = walker.walk(200)
	var furthest_room = walker.get_furthest_room(map[0]*32)
	walker.queue_free()
	for location in map:
		tilemap.set_cellv(location, -1)
	tilemap.update_bitmask_region(borders.position, borders.end)
	
	player.global_position = map[0]*32
	
	var door = exit.instance()
	door.global_position = furthest_room.pos*32
	add_child(door)
	
