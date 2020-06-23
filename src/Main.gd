extends Node2D

signal add_coin(area)
signal add_score(value)


export (PackedScene) var Enemy = null
export (PackedScene) var Coin = null

onready var screen_width = ProjectSettings.get_setting("display/window/size/width")
onready var screen_height = ProjectSettings.get_setting("display/window/size/height")

onready var world = $WorldGenerator

var __score: int = 0


func _ready() -> void:
	randomize()
	$Player.reset_camera(screen_width, screen_height)
	$Player.camera.connect("moved", self, "_on_PlayerCamera_moved")

	world.create_walls(-16, 16)
	create_level()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("zoom_in"):
		$Player.camera.zoom.x -= 0.5
		$Player.camera.zoom.y -= 0.5
	if event.is_action_pressed("zoom_out"):
		$Player.camera.zoom.x += 0.5
		$Player.camera.zoom.y += 0.5


func create_level() -> void:
	var positions =  world.create_levels(2)

	for pos in positions:
		instance_notifiers(pos)
		instance_enemies(pos)
		instance_coins(pos)


func instance_notifiers(new_position: Vector2) -> void:
	var notifier = VisibilityNotifier2D.new()
	notifier.position = new_position

	world.add_child(notifier)


func instance_enemies(new_position: Vector2) -> void:
	new_position.y -= world.tile_size.y
	new_position.x = rand_range(world.tile_size.x, screen_width - world.tile_size.x)
	var ant = Enemy.instance()
	ant.position = new_position
	ant.connect("killed", self, "_on_enemy_killed")
	$Enemies.add_child(ant)


func instance_coins(new_position: Vector2) -> void:
	for n in rand_range(1, 4):
		instance_coin(new_position)


func instance_coin(new_position: Vector2) -> void:
	new_position.y -= world.tile_size.y + world.tile_size.y * 2
	new_position.x = rand_range(world.tile_size.x, screen_width - world.tile_size.x)

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


func _on_PlayerCamera_moved(camera_position: Vector2) -> void:
	world.destroy_until(camera_position)
	create_level()


func _on_coin_collected(score) -> void:
	increase_score(score)
	$Collectables.sum_coin()


func _on_enemy_killed(score) -> void:
	increase_score(score)
	$Collectables.sum_enemies()


func _on_Player_hurted(life: int) -> void:
	increase_score(-20)
	$HUD.set_life(life)


func _on_Player_dead() -> void:
	var new = Data.save_score(__score)
	$HUD.show_game_over(new)
	$GameOverTimer.start(3)


func _on_GameOverTimer_timeout() -> void:
	get_tree().change_scene("res://src/UI/Menu.tscn")
