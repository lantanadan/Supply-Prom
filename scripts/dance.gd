extends Node2D

@onready var spot_up: Marker2D = $Game/Up
@onready var spot_right: Marker2D = $Game/Right
@onready var spot_down: Marker2D = $Game/Down
@onready var spot_left: Marker2D = $Game/Left

@export var beatArrow : PackedScene

@export var song : String
@export var randomize : bool = false
var beatLine : int = 0

var selectedArrow : int

func _ready() -> void:
	
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

func _on_timer_timeout() -> void:
	# Timer should be set to load 8th notes max
	# 0 skips the line
	# 1 = Up, 2 = Right, 3 = Down, 4 = Left
	beatLine += 1
	playBeat(beatLine)
	print("beat")

func load_json_data_from_path(path : String):
	# Setup variables. "filestring" loads the entire file as a single string that then gets parsed.
	var fileString = FileAccess.get_file_as_string(song)
	var jsonData
	
	# Parse the JSON down into its individual pieces.
	if fileString != null:
		jsonData = JSON.parse_string(fileString)
		
	else:
		push_warning("loading json data from path failed:", song)
	
	if jsonData == null:
		push_warning("couldn't parse json data from path:", song)
	
	return jsonData

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		GameState.checkBeat_up.emit()
	if Input.is_action_just_pressed("ui_right"):
		GameState.checkBeat_right.emit()
	if Input.is_action_just_pressed("ui_down"):
		GameState.checkBeat_down.emit()
	if Input.is_action_just_pressed("ui_left"):
		GameState.checkBeat_left.emit()
