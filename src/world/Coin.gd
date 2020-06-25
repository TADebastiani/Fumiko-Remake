extends Area2D

signal collected(coin)

var rect: Rect2
export var score = 10

func _ready() -> void:
	rect = Rect2(global_position, $Sprite.texture.get_size())


func _on_world_add_coin(coin: Area2D) -> void:
	if coin != self and rect.intersects(coin.rect):
		coin.queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Coin_body_entered(_body: Node) -> void:
	queue_free()
	emit_signal("collected", self)
