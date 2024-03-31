extends Node2D

@onready var outContestScene: OutContestScene = get_node("OutContestScene")
@onready var inContestScene: InContestScene = get_node("InContestScene")
@onready var contest: Contest

# Called when the node enters the scene tree for the first time.
func _ready():
	outContestScene.transition_to_contest.connect(start_transition_to_contest)
	outContestScene.visible = true
	inContestScene.visible = false


func start_transition_to_contest() -> void:
	contest = Contest.new()
	contest.create_contest(10)
	
	outContestScene.visible = false
	inContestScene.visible = true
	
	inContestScene.contest = contest
