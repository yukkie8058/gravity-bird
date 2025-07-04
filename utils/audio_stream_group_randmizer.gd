@tool
class_name AudioStreamGroupRandomizer
extends AudioStreamRandomizer

@export var stream_group: ResourceGroup:
	set = _set_stream_group

func _validate_property(property: Dictionary) -> void:
	if property["name"] == "streams" and property["usage"] == PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_ARRAY:
		property["name"] = "Streams"
		property["usage"] = PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_GROUP
		property["hint_string"] = "stream_"

func _set_stream_group(value: ResourceGroup) -> void:
	if stream_group != value:
		if stream_group != null and stream_group.changed.is_connected(_stream_group_changed):
			stream_group.changed.disconnect(_stream_group_changed)
		if value != null and value.changed.is_connected(_stream_group_changed):
			value.changed.connect(_stream_group_changed)
	
	stream_group = value
	
	_stream_group_changed()

func _stream_group_changed() -> void:
	if stream_group == null: return
	
	streams_count = 0
	var streams: Array[AudioStream]
	stream_group.load_all_into(streams)
	for stream in streams:
		add_stream(-1, stream)
