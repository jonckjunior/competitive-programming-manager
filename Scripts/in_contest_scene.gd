extends Node2D
class_name InContestScene

@export var timeToUpdateUI : float

@onready var problemController: Node2D = $ProblemController
@onready var uiToUpdate : Array = get_tree().get_nodes_in_group("updateUI")

var contest: Contest
var timeSinceUpdate: float

func _ready():
	contest = Contest.new()
	contest.create_contest(10)
	assert(contest.problemSet.size() == 16)
	var problems = problemController.get_children()
	for i in range(problems.size()):
		var problemPane = problems[i]
		
		problemPane.codeTimeBase = contest.problemSet[i].codingTimeBase
		problemPane.readTimeBase = contest.problemSet[i].readingTimeBase
		problemPane.solveTimeBase = contest.problemSet[i].solvingTimeBase
	
	var standingController : StandingController = $StandingPanel/ProblemHolder/ScrollContainer
	standingController.teams = contest.managers
	standingController.render_standings()


func _process(delta):
	uiToUpdate = get_tree().get_nodes_in_group("updateUI")
	update_UI(delta)

func update_UI(delta) -> void:
	timeSinceUpdate += delta
	if timeSinceUpdate > timeToUpdateUI:
		for ui in uiToUpdate:
			ui.frame = randi() % ui.sprite_frames.get_frame_count("default")
		timeSinceUpdate = 0.0
