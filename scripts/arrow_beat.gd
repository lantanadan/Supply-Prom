extends Node2D

var arrowID : int
var arrowDirection : int
@export var arrowNormal : Texture2D
@export var arrowHit : Texture2D
@export var arrowSpeed : float = 5.0
var accuracy : int
var overlap : bool = false
var arrowPressed : bool = false
var myGoal : Node

func _ready() -> void:
	GameState.connect("checkBeat_up",checkBeat_up)
	GameState.connect("checkBeat_down",checkBeat_down)
	GameState.connect("checkBeat_left",checkBeat_left)
	GameState.connect("checkBeat_right",checkBeat_right)
	
	$Rushed.area_entered.connect(plusAccuracy)
	$Rushed.area_exited.connect(minusAccuracy)
	$Okay.area_entered.connect(plusAccuracy)
	$Okay.area_exited.connect(minusAccuracy)
	$Okay.area_exited.connect(fadeOut)
	$Good.area_entered.connect(plusAccuracy)
	$Good.area_exited.connect(minusAccuracy)
	$Awesome.area_entered.connect(plusAccuracy)
	$Awesome.area_exited.connect(minusAccuracy)

	if arrowDirection == 0:
		modulate = Color(1.0, 1.0, 0.5, 1.0)
	if arrowDirection == 1:
		modulate = Color(1.0, 0.5, 0.5, 1.0)
	if arrowDirection == 2:
		modulate = Color(0.5, 1.0, 0.5, 1.0)
	if arrowDirection == 3:
		modulate = Color(0.5, 0.5, 1.0, 1.0)
	
func _process(delta: float) -> void:
	if arrowPressed == false:
		if arrowDirection == 0:
			position.y += arrowSpeed * delta
		if arrowDirection == 1:
			position.x -= arrowSpeed * delta
			rotation_degrees = 90
		if arrowDirection == 2:
			position.y -= arrowSpeed * delta
			rotation_degrees = 180
		if arrowDirection == 3:
			position.x += arrowSpeed * delta
			rotation_degrees = 270

func plusAccuracy(target):
	if target.is_in_group("Goal"):
		myGoal = target
		myGoal.arrowID = arrowID
		overlap = true
		if accuracy < 4:
			accuracy += 1
	#if target.is_in_group("Beat"):
		#$Awesome.monitoring = false
		#$Good.monitoring = false
		#$Okay.monitoring = false
		#$Rushed.monitoring = false

func minusAccuracy(target):
	if target.is_in_group("Goal"):
		if accuracy > 0:
			accuracy -= 1
	#if target.is_in_group("Beat"):
		#$Awesome.monitoring = true
		#$Good.monitoring = true
		#$Okay.monitoring = true
		#$Rushed.monitoring = true

func fadeOut(target):
	if target.is_in_group("Goal"):
		var fadeTween = create_tween().tween_property(self,"modulate:a",0,0.33)
		await fadeTween.finished
		queue_free()

func hit():
	arrowPressed = true
	GameState.scoreTemp += accuracy
	if GameState.multiplier < 8:
		GameState.multiplier += 1
	$ArrowSprite.texture = arrowHit
	GameState.updateScore.emit()
	var fastFade = create_tween().tween_property(self,"modulate:a",0,0.15)
	await fastFade.finished
	queue_free()

func missed():
	GameState.score += GameState.scoreTemp * GameState.multiplier

func checkBeat_up():
	if overlap == true and myGoal.arrowID == arrowID:
		if arrowDirection == 0:
			hit()
		else:
			GameState.multiplier = 1
			missed()
	else:
		missed()

func checkBeat_right():
	if overlap == true and myGoal.arrowID == arrowID:
		if arrowDirection == 1:
			hit()
		else:
			GameState.multiplier = 1
			missed()
	else:
		missed()

func checkBeat_down():
	if overlap == true and myGoal.arrowID == arrowID:
		if arrowDirection == 2:
			hit()
		else:
			GameState.multiplier = 1
			missed()
	else:
		missed()
		
func checkBeat_left():
	if overlap == true and myGoal.arrowID == arrowID:
		if arrowDirection == 3:
			hit()
		else:
			GameState.multiplier = 1
			missed()
	else:
		missed()
