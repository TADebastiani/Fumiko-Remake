extends HBoxContainer

var __max_steps: int = 6
var current_step: int = 6


onready var hearts: Array = [
	$Heart1,
	$Heart2,
	$Heart3
]


func _ready() -> void:
	set_max()


func set_max() -> void:
	current_step = __max_steps
	update()


func set_min() -> void:
	current_step = 0
	update()


func set_step(value: int) -> void:
	current_step = int(clamp(value, 0, __max_steps))
	update()


func reduce() -> void:
	if current_step > 0:
		current_step -= 1
	update()


func increase() -> void:
	if current_step < __max_steps:
		current_step += 1
	update()


func update() -> void:
	var values = [0, 0, 0]
	var h = 0

	for s in range(1, __max_steps + 1):
		if s <= current_step:
			values[h] += 1
		if s % 2 == 0:
			h += 1

	for h in hearts.size():
		hearts[h].value = values[h]
