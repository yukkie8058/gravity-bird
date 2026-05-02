class_name Save
extends SaveFile

static func get_singleton() -> Save: return Engine.get_singleton("Save") as Save

static func _static_init() -> void:
	var instance := new()
	assert(instance.reference())
	Engine.register_singleton("Save", instance)

func _init() -> void:
	assert(not Engine.has_singleton("Save"), error_string(ERR_ALREADY_EXISTS))
	super("user://save.dat")

#region エントリの定義

var high_score: int:
	set(v): assert(v >= 0, error_string(ERR_PARAMETER_RANGE_ERROR)); set_value("high_score", v)
	get: return get_value("high_score") if has_value("high_score") else 0
var audio_mute: bool:
	set(v): set_value("audio_mute", v)
	get: return get_value("audio_mute") if has_value("audio_mute") else false

#endregion
