class_name MainState
extends StateChart

static var _instance: MainState

static func chart() -> MainState: return _instance
static func root() -> CompoundState: return _instance._state

func _init() -> void:
	if _instance != null:
		push_error("MainStateは複数存在できません")
		return
	_instance = self

# github.com/godotengine/godot/issues/83549を誰か早く直してくれ...
func send_event(event: StringName) -> void: super(event)

