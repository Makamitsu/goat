extends CheckButton

@export var settings_section: String = ""
@export var settings_key: String = ""

func _ready():
	if !settings_section.is_empty() and !settings_key.is_empty():
		set_pressed_no_signal(goat_settings.get_value(settings_section, settings_key))


func _on_SettingsCheckButton_pressed():
	if !settings_section.is_empty() and !settings_key.is_empty():
		goat_settings.set_value(settings_section, settings_key, button_pressed)
