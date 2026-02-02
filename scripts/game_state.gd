extends Node

signal checkBeat_up
signal checkBeat_right
signal checkBeat_down
signal checkBeat_left
signal updateScore

var scoreTemp : int = 0
var score : int = 0
var multiplier : int = 1

func reset():
	score = 0
	multiplier = 0
