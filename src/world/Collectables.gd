extends Node

var coins_count: int = 0
var enemies_count: int = 0


func sum_coin() -> void:
	coins_count += 1


func sum_enemies() -> void:
	enemies_count += 1


func reset() -> void:
	coins_count = 0
	enemies_count = 0
