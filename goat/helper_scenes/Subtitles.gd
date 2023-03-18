extends Control

@onready var text_box = $TextBox
@onready var text = $TextBox/Label


func _ready():
	goat_voice.connect("started",Callable(self,"show_subtitles"))
	goat_voice.connect("finished",Callable(self,"hide_subtitles"))
	goat_settings.value_changed.connect(self._on_settings_changed)


func show_subtitles(audio_name):
	"""Show a bottom bar with subtitles"""
	text.text = goat_voice.get_transcript(audio_name)
	if goat_settings.get_value("gui", "subtitles"):
		text_box.show()


func hide_subtitles(_audio_name):
	"""Hide subtitles"""
	text.text = ""
	text_box.hide()


func _on_settings_changed(gui, subtitles):
	"""
	Changes the visibility of subtitles, but only if they should be displayed
	at the moment.
	"""
	if gui == "gui" and subtitles == "subtitles" and text.text:
		text_box.visible = goat_settings.get_value("gui", "subtitles")
