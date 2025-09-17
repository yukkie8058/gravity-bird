@tool
class_name ThemeExValue
extends Texture2D
## Allows storing any type of Resource in a Theme.

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_ALWAYS_DUPLICATE)
var value: Resource:
	set = _set_value

func _init() -> void:
	if value != null:
		value.changed.connect(emit_changed)

func _set_value(new_value: Resource) -> void:
	if value == new_value: return
	
	if value != null:
		value.changed.disconnect(emit_changed)
	if new_value != null:
		new_value.changed.connect(emit_changed)
	
	value = new_value
	
	emit_changed()

func _get_width() -> int: return 0
func _get_height() -> int: return 0

func _validate_property(property: Dictionary) -> void:
	var script_variable := property["usage"] as int & PROPERTY_USAGE_SCRIPT_VARIABLE != 0
	var resource := (property["name"] as String).begins_with("resource_")
	if not (script_variable or resource):
		property["usage"] = PROPERTY_USAGE_NONE
