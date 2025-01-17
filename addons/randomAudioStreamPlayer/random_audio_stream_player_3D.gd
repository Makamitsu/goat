@tool
extends AudioStreamPlayer3D

@export var streams : Array[AudioStream]  # (Array, AudioStream)

enum Strategy {
	Pure = 0,
	NoConsecutive = 1,
	RunAllOnce = 2
}
@export var random_strategy: Strategy = Strategy.Pure # (int, "Pure", "No consecutive repetition", "Use all samples before repeat")

@export var randomize_volume: bool = false
@export_range(-80, 24, 0.1) var volume_min: float = 0 # (float, -80, 24)
@export_range(-80, 24, 0.1) var volume_max: float = 0 # (float, -80, 24)

@export var randomize_pitch: bool = false
@export_range(0.01, 32, 0.01) var pitch_min: float = 1 # (float, 0.01, 32)
@export_range(0.01, 32, 0.01) var pitch_max: float = 1 # (float, 0.01, 32)

var playing_sample_nb : int = -1
var last_played_sample_nb : int = -1 # only used if random_strategy = 1
var playing_time_remaining = -1
var to_play = []

func play(from_position=0.0):
	var number_of_samples = len(streams)
	if number_of_samples > 0:
		if playing_sample_nb < 0:
			if number_of_samples == 1:
				playing_sample_nb = 0
			else:
				randomize()
				match random_strategy:
					1:
						playing_sample_nb = randi() % (number_of_samples - 1)
						if last_played_sample_nb == playing_sample_nb:
							playing_sample_nb += 1
						last_played_sample_nb = playing_sample_nb
					2:
						if len(to_play) == 0:
							for i in range(number_of_samples):
								if i != last_played_sample_nb:
									to_play.append(i)
							to_play.shuffle()
						playing_sample_nb = to_play.pop_back()
						last_played_sample_nb = playing_sample_nb
					_:
						playing_sample_nb = randi() % number_of_samples
			if randomize_volume:
				set_volume_db(randf_range(volume_min, volume_max))
			if randomize_pitch:
				set_pitch_scale(randf_range(pitch_min, pitch_max))
		set_stream(streams[playing_sample_nb])
		super.play(from_position)

func _ready():
	connect("finished",Callable(self,"reset_playing_sample_nb"))

func reset_playing_sample_nb():
	if playing_sample_nb >= 0:
		playing_sample_nb = -1

