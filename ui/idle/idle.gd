extends MarginContainer

@export_group("Component")
@export var _audio_mute: CheckButton
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

	_audio_mute.button_pressed = Save.get_singleton().audio_mute

func _audio_mute_toggled(toggled_on: bool) -> void:
	var bus := 0
	AudioServer.set_bus_mute(bus, toggled_on)
	Save.get_singleton().audio_mute = toggled_on

func _instruction_timer_timeout() -> void:
	_instruction.visible = not _instruction.visible
