extends Node

const __save_path = "user://save.dat"
const password = "TADebastiani"


static func _save(score: int) -> void:

	var save_file = File.new()
#	save_file.open_encrypted_with_pass(__save_path, File.WRITE, password)
	save_file.open(__save_path, File.WRITE)

	save_file.store_line(str(score))
	save_file.close()


static func _load() -> int:
	var save_file = File.new()
	var data = 0

	if save_file.file_exists(__save_path):
#		save_file.open_encrypted_with_pass(__save_path, File.READ, password)
		save_file.open(__save_path, File.READ)
		data = int(save_file.get_line())

	print(data)
	save_file.close()
	return data


static func save_score(score: int) -> bool:
	var old_score = _load()

	if score > old_score:
		_save(score)
		return true
	else:
		return false


static func load_score() -> int:
	return _load()
