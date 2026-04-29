extends "res://addons/gd-plug/plug.gd"

func _plugging() -> void:
	plug("derkork/godot-statecharts", {
		"tag": "v0.22.4",
		"include": ["addons/godot_state_charts"],
		"exclude": ["addons/godot_state_charts/csharp"],
	})
	plug("derkork/godot-resource-groups", {
		"tag": "v0.4.0",
		"include": ["addons/godot_resource_groups"],
		"exclude": ["addons/godot_resource_groups/csharp"],
	})
