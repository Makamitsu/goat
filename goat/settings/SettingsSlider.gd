extends HSlider

@export var settings_section: String = ""
@export var settings_key: String = ""


func _ready():
	if !settings_section.is_empty() and !settings_key.is_empty():
		value = goat_settings.get_value(settings_section, settings_key)


func _on_SettingsSlider_value_changed(new_value):
	if !settings_section.is_empty() and !settings_key.is_empty():
		goat_settings.set_value(settings_section, settings_key, new_value)
