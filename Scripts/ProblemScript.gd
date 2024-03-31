extends Node2D
class_name MetalPanelProblem
@onready var workingPanel : ProblemPanelDropable = $WorkingPanel

@onready var readText = $ProblemSheet/ReadControl/ReadProblemPanel
@onready var solveText = $ProblemSheet/SolveControl/SolveProblemPanel
@onready var codeText = $ProblemSheet/CodeControl/CodeProblemPanel

@onready var progressBarAssets = [
	load("res://Assets/problem_panel_loading_bar/problem_panel_loading_bar1.png"),
	load("res://Assets/problem_panel_loading_bar/problem_panel_loading_bar2.png"),
	load("res://Assets/problem_panel_loading_bar/problem_panel_loading_bar3.png"),
]

@onready var progressBarFullAssets = [
	load("res://Assets/problem_panel_loading_bar/player_panel_loading_bar_full1.png"),
	load("res://Assets/problem_panel_loading_bar/player_panel_loading_bar_full2.png"),
	load("res://Assets/problem_panel_loading_bar/player_panel_loading_bar_full3.png"),
]

@export var readProgressBar: TextureProgressBar
@export var solveProgressBar: TextureProgressBar
@export var codeProgressBar: TextureProgressBar

@export var readTimeBase : float
@export var solveTimeBase : float
@export var codeTimeBase : float
@export var timeToUpdateUI : float

var problemElo : int

var readProgress: float = 0.0
var solveProgress: float = 0.0
var codeProgress: float = 0.0
var delayProgress: float = 0.0
var timeSinceUpdate: float = 0.0
var uiProgressBarToUpdate: Array

func _ready():
	uiProgressBarToUpdate = [$ProblemSheet/ReadControl/ReadProgressBar, $ProblemSheet/SolveControl/SolveProgressBar, $ProblemSheet/CodeControl/CodeProgressBar]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_UI(delta)
	if not workingPanel.objectsAttached.is_empty():
		if delayProgress < 1.0:
			delayProgress = min(delayProgress + delta, 1.0)
			return

		if readProgress < readTimeBase:
			readProgress = min(readProgress + delta, readTimeBase)
			readProgressBar.value = int(readProgress * 100 / readTimeBase)
			readProgressBar.tint_progress = Color("f7ee46")
		elif solveProgress < solveTimeBase:
			solveProgress = min(solveProgress + delta, solveTimeBase)
			solveProgressBar.value = int(solveProgress * 100 / solveTimeBase)
			
			readProgressBar.tint_progress = Color("97ee46")
			solveProgressBar.tint_progress = Color("f7ee46")
		elif codeProgress < codeTimeBase:
			codeProgress = min(codeProgress + delta, codeTimeBase)
			codeProgressBar.value = int(codeProgress * 100 / codeTimeBase)
		
			readProgressBar.tint_progress = Color("97ee46")
			solveProgressBar.tint_progress = Color("97ee46")
			codeProgressBar.tint_progress = Color("f7ee46")
		else:
			readProgressBar.tint_progress = Color("97ee46")
			solveProgressBar.tint_progress = Color("97ee46")
			codeProgressBar.tint_progress = Color("97ee46")
	else:
		delayProgress = 0.0

func update_UI(delta) -> void:
	timeSinceUpdate += delta
	if timeSinceUpdate > timeToUpdateUI:
		for ui in uiProgressBarToUpdate:
			var posUnder = randi() % 3
			var posProgress = randi() % 3
			ui.texture_under = progressBarAssets[posUnder]
			ui.texture_progress = progressBarFullAssets[posProgress]
		
		timeSinceUpdate = 0.0
