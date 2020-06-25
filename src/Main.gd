extends Node2D

signal add_coin(area)


export (PackedScene) var Enemy = null
export (PackedScene) var Coin = null
export (PackedScene) var DebugLayer = null

onready var screen_width = ProjectSettings.get_setting("display/window/size/width")
onready var screen_height = ProjectSettings.get_setting("display/window/size/height")

onready var world = $WorldGenerator

onready var min_width = world.tile_size.x * 2
onready var max_width = screen_width - min_width

var __score: int = 0


func _ready() -> void:
	instance_debug()
	randomize()
	$Player.reset_camera(screen_width, screen_height)
	$Player.camera.connect("moved", self, "_on_PlayerCamera_moved")

	world.create_walls(-16, 16)

	# Start with 3 levels, 1st withput mobs/coins
	world.create_level()
	create_level()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		var err = get_tree().reload_current_scene()
		if err:
			print("Error reseting game!")
			print(err)
	if event.is_action_pressed("zoom_in"):
		$Player.camera.zoom.x -= 0.5
		$Player.camera.zoom.y -= 0.5
	if event.is_action_pressed("zoom_out"):
		$Player.camera.zoom.x += 0.5
		$Player.camera.zoom.y += 0.5
	if event.is_action_pressed("debug"):
		$DebugLayer.toggle()


func create_level() -> void:
	var position =  world.create_levels(1)

	for pos in position:
		instance_coins(pos[0])
		instance_enemies(pos[0], pos[1])


func instance_enemies(new_position: Vector2, gap: Array) -> void:
	new_position.y -= world.tile_size.y
	new_position.x = rand_range(min_width, max_width)

	if new_position.x >= gap[0] and new_position.x <= gap[1]:
		if gap[1] >= max_width - (world.tile_size.x * 3):
			new_position.x = gap[0] - world.tile_size.x * 3
		else:
			new_position.x = gap[1] + world.tile_size.x * 3

	var ant = Enemy.instance()
	ant.position = new_position
	ant.connect("killed", self, "_on_enemy_killed")
	$Enemies.add_child(ant)
	$DebugLayer.add_stat(ant.get_instance_id(),
		"Ant (%d)" % ant.get_instance_id(),
		ant, "get_position", true
	)


func instance_coins(new_position: Vector2) -> void:
	for n in rand_range(1, 4):
		instance_coin(new_position)


func instance_coin(new_position: Vector2) -> void:
	new_position.y -= world.tile_size.y + world.tile_size.y * 2
	new_position.x = rand_range(world.tile_size.x * 2, screen_width - (world.tile_size.x * 2))

	var coin = Coin.instance()
	connect("add_coin", coin, "_on_world_add_coin")
	coin.connect("collected", self, "_on_coin_collected")
	coin.position = new_position

	$Coins.add_child(coin)
	emit_signal("add_coin", coin)


func increase_score(value) -> void:
	__score += value
	if __score < 0:
		__score = 0
	$HUD.set_score(__score)


func instance_debug() ->void:
	var debug = DebugLayer.instance()
	debug.add_stat(0, "FPS", Engine, "get_frames_per_second", true)
	debug.add_stat(1, "Static memory", OS, "get_static_memory_usage", true)
	debug.add_stat(2, "Player", $Player, "get_position", true)
	debug.hide()
	add_child(debug)


func _on_PlayerCamera_moved(camera_position: Vector2) -> void:
	world.destroy_until(camera_position)
	create_level()


func _on_coin_collected(coin) -> void:
	increase_score(coin.score)
	$Collectables.sum_coin()


func _on_enemy_killed(enemy) -> void:
	increase_score(enemy.score)
	$Collectables.sum_enemies()
	$DebugLayer.remove_stat(enemy.get_instance_id())


func _on_Player_hurted(life: int) -> void:
	increase_score(-20)
	$HUD.set_life(life)


func _on_Player_dead() -> void:
	var new = Data.save_score(__score)
	$HUD.show_game_over(new)
	$GameOverTimer.start(3)


func _on_GameOverTimer_timeout() -> void:
	var err = get_tree().change_scene("res://src/UI/Menu.tscn")
	if err:
		print("Error loading Menu scene")
		print(err)
