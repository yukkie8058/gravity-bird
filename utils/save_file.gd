class_name SaveFile
extends RefCounted

var _file: FileAccess

func _init(path: String) -> void:
	_file = FileAccess.open(
		path,
		FileAccess.READ_WRITE if FileAccess.file_exists(path) else FileAccess.WRITE_READ,
	)
	assert(_file != null, error_string(FileAccess.get_open_error()))

func set_value(key: String, value: Variant) -> void:
	var dict := _file_get_as_dict()
	assert(dict.set(key, value))
	
	_file.seek(0)
	assert(_file.store_var(dict), error_string(_file.get_error()))
	var err := _file.resize(_file.get_position())
	assert(err == OK, error_string(err))
	
	_file.flush()

func get_value(key: String) -> Variant:
	return _file_get_as_dict().get(key)

func has_value(key: String) -> bool:
	return _file_get_as_dict().has(key)

func _file_get_as_dict() -> Dictionary:
	if _file.get_length() < 4:
		return {}
	_file.seek(0)
	return _file.get_var() as Dictionary
