@tool
class_name VisibleState
extends AtomicState
## 状態に合わせて、[member target_node]に設定されたノードの可視性を切り替えます。
## UIの可視性の切替に便利です。

## 可視性を切り替えるノード。
@export var target_node: Node:
	set(v): target_node = v; update_configuration_warnings()

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	if not is_instance_valid(target_node):
		push_error("The node is invalid. This node will not work.")
		return
	if not "visible" in target_node:
		push_error("The node does not have a visible property. This node will not work.")
		return
	
	_update_visibility()

@warning_ignore("unused_parameter")
func _state_enter(expect_transition: bool = false) -> void:
	super()
	_update_visibility()

func _state_exit() -> void:
	super()
	_update_visibility()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if target_node == null:
		warnings.append("No node is set.")
	if target_node != null and not "visible" in target_node:
		warnings.append("The node does not have a visible property.")
	
	return warnings

func _update_visibility() -> void:
	if not is_instance_valid(target_node): return
	if not "visible" in target_node: return
	
	target_node["visible"] = active
