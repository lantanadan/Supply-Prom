extends Node2D

@onready var spot_up: Marker2D = $Game/Up
@onready var spot_right: Marker2D = $Game/Right
@onready var spot_down: Marker2D = $Game/Down
@onready var spot_left: Marker2D = $Game/Left
@onready var music: AudioStreamPlayer = $Music
@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier

@export var beatArrow : PackedScene

@export var song : AudioStreamOggVorbis
@export var song_file_path: String
var song_file : FileAccess
var song_string : String
@export var randomize : bool = false
var beatLine : int = 0

var selectedArrow : int

func _ready() -> void:

	if song != null:
		music.stream = song
		music.play()
	if song_file_path != null:
		# First we open the song file from the path
		song_file = FileAccess.open(song_file_path,FileAccess.READ)
		song_string = song_file.get_as_text()
		
		# Then we create a TextEdit object out of the SM file
		var get_text_lines : TextEdit = TextEdit.new()
		get_text_lines.text = song_string
		
		# Then we get the line containing the BPM
		var bpm_line : String = str(get_text_lines.get_line_wrapped_text(9))
		
		# Then we run a RegEx search to grab the contained int. This way we don't have to worry
		# about if it's 1bpm or 1000bpm, it'll grab the number regardless
		var regex = RegEx.new()
		regex.compile("\\d+")
		var my_bpm = regex.search_all(bpm_line)
	
		# Finally we take the found number and feed it into the BPM value
		for number in my_bpm:
			var number_found = number.get_string()
			rhythm_notifier.bpm = int(number_found)

		music.songData = song_file_path
		rhythm_notifier.running = true

	if randomize == true:
		$Timer.start()

func playBeat(beat) -> void:
	if randomize == true:
		selectedArrow = randi_range(0,4)
		var newArrow = beatArrow.instantiate()
		if selectedArrow == 1:
			newArrow.position = spot_up.position
			newArrow.arrowDirection = 0
			newArrow.arrowID = beatLine
			add_child(newArrow)
		if selectedArrow == 2:
			newArrow.position = spot_right.position
			newArrow.arrowDirection = 1
			newArrow.arrowID = beatLine
			add_child(newArrow)
		if selectedArrow == 3:
			newArrow.position = spot_down.position
			newArrow.arrowDirection = 2
			newArrow.arrowID = beatLine
			add_child(newArrow)
		if selectedArrow == 4:
			newArrow.position = spot_left.position
			newArrow.arrowDirection = 3
			newArrow.arrowID = beatLine
			add_child(newArrow)
	else:
		pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		GameState.checkBeat_up.emit()
	if Input.is_action_just_pressed("ui_right"):
		GameState.checkBeat_right.emit()
	if Input.is_action_just_pressed("ui_down"):
		GameState.checkBeat_down.emit()
	if Input.is_action_just_pressed("ui_left"):
		GameState.checkBeat_left.emit()


func _on_rhythm_notifier_beat(current_beat: int) -> void:
	playBeat(current_beat)
