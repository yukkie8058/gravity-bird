extends "res://addons/gd-plug/plug.gd"

func _plugging() -> void:
	plug("derkork/godot-statecharts", {
		"tag": "v0.17.0", 
		"exclude": ["addons/godot_state_charts/csharp"], 
	})
	plug("derkork/godot-resource-groups", {
		"tag": "v0.4.0", 
		"exclude": ["addons/godot_resource_groups/csharp"],
	})

