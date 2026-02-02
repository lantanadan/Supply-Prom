extends Control

@export var scoreCounter : Node
var lastScore : int = 0

func _ready() -> void:
	GameState.connect("updateScore",scrollScore)

func _process(delta: float) -> void:
	scoreCounter.text = str(lastScore)

func scrollScore():
	var _updateScore = create_tween().tween_property(self,"lastScore",GameState.score,1)
	
