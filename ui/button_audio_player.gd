extends AudioStreamPlayer

var _pressed_callables: Dictionary[BaseButton, Callable]

func _enter_tree() -> void:
	get_tree().node_added.connect(_tree_node_added)

func _exit_tree() -> void:
	get_tree().node_added.disconnect(_tree_node_added)

func _tree_node_added(node: Node) -> void:
	if node is BaseButton:
		var button := node as BaseButton
		button.theme_changed.connect(_button_theme_changed.bind(button))
		_pressed_connect(button)

func _button_theme_changed(button: BaseButton) -> void:
	if _pressed_callables.has(button):
		button.pressed.disconnect(_pressed_callables[button])
	_pressed_connect(button)

func _pressed_connect(button: BaseButton) -> void:
	var playback := get_stream_playback() as AudioStreamPlaybackPolyphonic
	var audio := (button.get_theme_icon("audio_pressed") as ThemeExValue).value as AudioStream
	_pressed_callables[button] = playback.play_stream.bind(audio)
	button.pressed.connect(_pressed_callables[button])
