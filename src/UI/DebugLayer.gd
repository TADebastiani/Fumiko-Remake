extends CanvasLayer

var stats = []


func hide() -> void:
	$Info.visible = false


func show() -> void:
	$Info.visible = true


func toggle() -> void:
	$Info.visible = not $Info.visible


func add_stat(stat_name, object, stat_ref, is_method):
	stats.append({
		"name": stat_name,
		"object": object,
		"ref": stat_ref,
		"is_method": is_method
	})


func _process(_delta: float) -> void:
	var final_text = ""

	for s in stats:
		var value
		if s.object and weakref(s.object).get_ref():
			if s.is_method:
				value = s.object.call(s.ref)
			else:
				value = s.object.get(s.ref)
		final_text += str(s.name, ": ", value)
		final_text += "\n"

	$Info.text = final_text
