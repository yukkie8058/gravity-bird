extends MarginContainer

@export_group("Component")
@export var _sound_toggle: Button
@export var _version: LinkButton
@export var _instruction: Label

func _enter_tree() -> void:
	var project_version := ProjectSettings.get_setting("application/config/version")
	_version.text = "VER. %s" % project_version
	_version.uri = "https://github.com/yukkie8058/gravity-bird/blob/%s/CHANGELOG.md" % project_version

	_instruction.visible = false
	var mobile := ["mobile", "web_android", "web_ios"].any(OS.has_feature)
	_instruction.text = "" if mobile else "PRESS SPACE\nOR\n"
	_instruction.text += "%s ANYWHERE" % ("TOUCH" if mobile else "CLICK")

	_mute_changed()

func _sound_toggle_pressed() -> void:
	var save := Save.get_singleton()
	save.audio_mute = not save.audio_mute
	_mute_changed()

func _instruction_timer_timeout() -> void:
	_instruction.visible = not _instruction.visible

func _mute_changed() -> void:
	var save := Save.get_singleton()
	var bus := 0
	AudioServer.set_bus_mute(bus, save.audio_mute)
	_sound_toggle.theme_type_variation = "SoundToggle%s" % ("Off" if save.audio_mute else "On")
