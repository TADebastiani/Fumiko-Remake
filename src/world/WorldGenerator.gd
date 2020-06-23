extends Node2D

export var default_tile = 1

var level_height = 4

var screen_width = ProjectSettings.get_setting("display/window/size/width")
var screen_height = ProjectSettings.get_setting("display/window/size/height")

onready var tiles_per_level = int(screen_width / $TileMap.cell_size.x)
onready var tile_size = $TileMap.cell_size

func _ready() -> void:
	randomize()


func destroy_until(point: Vector2) -> void:
	point = $TileMap.world_to_map(point)
	var start_y = $TileMap.get_used_rect().position.y

	for y in range(start_y, point.y - level_height * 3):
		for x in range(-1, tiles_per_level + 1):
			$TileMap.set_cell(x, y, -1)


func create_levels(size: int) -> Array:
	var positions = []
	for _i in range(size):
		positions.append(create_level())
	return positions


func create_level() -> Vector2:
	var start_y = $TileMap.get_used_rect().end.y
	var gap = int(rand_range(2, tiles_per_level - 2))
	var y = start_y + level_height

	# Walls
	create_walls(start_y)

	# Floor
	for x in range(0, tiles_per_level):
		if x != gap and x != gap + 1:
			$TileMap.set_cell(x, y, default_tile)
	$TileMap.update_bitmask_region(Vector2(0, y), Vector2(tiles_per_level, y))

	return $TileMap.map_to_world(Vector2(0, y))


func create_walls(start_y: int, end_y: int = level_height) -> void:
	for y in end_y:
		$TileMap.set_cell(0, y + start_y, default_tile)
		$TileMap.set_cell(tiles_per_level-1, y + start_y, default_tile)

	$TileMap.update_bitmask_region(Vector2(0, start_y), Vector2(1, end_y))
	$TileMap.update_bitmask_region(Vector2(tiles_per_level, start_y), Vector2(1, end_y))

