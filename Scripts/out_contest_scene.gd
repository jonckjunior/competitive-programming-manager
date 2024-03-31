extends Node2D
class_name OutContestScene

@onready var nextContestButton: Button = get_node("Control/NextContestButton")

signal transition_to_contest

func _ready():
	nextContestButton.pressed.connect(nextContestButtonPressed)

func nextContestButtonPressed() -> void:
	transition_to_contest.emit()
