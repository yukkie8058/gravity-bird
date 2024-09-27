extends ParallaxBackground

@export var _group_background: ResourceGroup
@export var _group_foreground: ResourceGroup
@export_group("Component")
@export var _sprite_background: Sprite2D
@export var _sprite_foreground: Sprite2D

var _backgrounds: Array[Texture2D]
var _foregrounds: Array[Texture2D]

func _enter_tree() -> void:
	_group_background.load_all_into(_backgrounds)
	_group_foreground.load_all_into(_foregrounds)
	for texture in _backgrounds + _foregrounds:
		assert(texture.resource_path.is_absolute_path())
		var f := texture.resource_path.get_file()
		assert(f.substr(0, 3) == "set")
		for c in f.substr(3):
			assert(c.is_valid_int() or "_")
			if c == "_": break

func _idle_state_entered() -> void:
	_sprite_background.texture = _backgrounds.pick_random()
	_sprite_foreground.texture = _foregrounds.filter(func(elem: Texture2D) -> bool:
		var elem_n := elem.resource_path.get_file()[3]
		var back_n := _sprite_background.texture.resource_path.get_file()[3]
		if elem_n == back_n: return false
		return true
	).pick_random()
