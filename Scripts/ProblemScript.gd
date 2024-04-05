extends Node2D
class_name MetalPanelProblem
@onready var workingPanel : ProblemPanelDropable = $WorkingPanel

@onready var readText = $ProblemSheet/ReadControl/ReadProblemPanel
@onready var solveText = $ProblemSheet/SolveControl/SolveProblemPanel
@onready var codeText = $ProblemSheet/CodeControl/CodeProblemPanel
@onready var problemTags = $ProblemSheet/TagControl.get_children()
@onready var problemPanelScratch = $ProblemPanelScratch
@onready var acBalloonPositionMarker: Marker2D = $AcBalloonMarkerPosition
@onready var problemSheet: AnimatedSprite2D = $ProblemSheet

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
@export var timeToUpdateUI : float
@export var readingBoost: float = 200.0

var problem: Problem

var readProgress: float = 0.0
var solveProgress: float = 0.0
var codeProgress: float = 0.0
var delayProgress: float = 0.0
var timeSinceUpdate: float = 0.0
var uiProgressBarToUpdate: Array

var judging: bool = false

signal problem_solved(problemNumber)

func _ready():
	var colorArray = [Color.BROWN, Color.DARK_ORANGE, Color.DARK_SLATE_BLUE]
	uiProgressBarToUpdate = [$ProblemSheet/ReadControl/ReadProgressBar, $ProblemSheet/SolveControl/SolveProgressBar, $ProblemSheet/CodeControl/CodeProgressBar]
	for tag in problemTags:
		tag.visible = false
		tag.modulate = colorArray.pick_random()
	problemPanelScratch.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_UI(delta)
	
	if not workingPanel.objectsAttached.is_empty():
		if delayProgress < 1.0:
			delayProgress = min(delayProgress + delta, 1.0)
			return
		
		if judging:
			return

		assert(problem.readingTimeBase != 0.0)
		if readProgress < problem.readingTimeBase:
			readProgress = min(readProgress + delta, problem.readingTimeBase)
			readProgressBar.value = int(readProgress * 100 / problem.readingTimeBase)
			
			# just finished reading
			if readProgress == problem.readingTimeBase:
				var problemResult = successfulRead()
				judging = true
				await blinkBar(readProgressBar)
				judging = false
				
				if problemResult:
					# problem pass
					readProgressBar.tint_progress = Color(1, 4, 1)
					for tag in problemTags:
						tag.visible = true
				else:
					# problem fail
					readProgressBar.tint_progress = Color(4, 1, 1)
					judging = true
					await blinkBar(readProgressBar)
					judging = false
					readProgress = 0.0
					readProgressBar.value = 0
					readProgressBar.tint_progress = Color(1, 1, 1)

		elif solveProgress < problem.solvingTimeBase:
			solveProgress = min(solveProgress + delta, problem.solvingTimeBase)
			solveProgressBar.value = int(solveProgress * 100 / problem.solvingTimeBase)

			# just finished reading
			if solveProgress == problem.solvingTimeBase:
				var problemResult = successfulSolve()
				judging = true
				await blinkBar(solveProgressBar)
				judging = false
				
				if problemResult:
					# problem pass
					solveProgressBar.tint_progress = Color(1, 4, 1)
				else:
					# problem fail
					solveProgressBar.tint_progress = Color(4, 1, 1)
					judging = true
					await blinkBar(solveProgressBar)
					judging = false
					solveProgress = 0.0
					solveProgressBar.value = 0
					solveProgressBar.tint_progress = Color(1, 1, 1)
		elif codeProgress < problem.codingTimeBase:
			codeProgress = min(codeProgress + delta, problem.codingTimeBase)
			codeProgressBar.value = int(codeProgress * 100 / problem.codingTimeBase)
			
			# just finished readsing
			if codeProgress == problem.codingTimeBase:
				judging = true
				await blinkBar(codeProgressBar)
				judging = false
				
				if true:
					# problem pass
					codeProgressBar.tint_progress = Color(1, 4, 1)
					problem_solved.emit(problem.problemNumber)
					
					problemPanelScratch.visible = true
					
				else:
					# problem fail
					codeProgressBar.tint_progress = Color(4, 1, 1)
					judging = true
					await blinkBar(codeProgressBar)
					judging = false
					codeProgress = 0.0
					codeProgressBar.value = 0
					codeProgressBar.tint_progress = Color(1, 1, 1)
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

func successfulRead() -> bool:
	var draggableCompetitors = workingPanel.objectsAttached
	assert(!draggableCompetitors.is_empty())
	
	var competitorElo = calculate_elo(draggableCompetitors)
	print("solve attempt")
	print(str(draggableCompetitors[0].competitor.elo) + " " + str(competitorElo))
	
	var eloDifference = competitorElo - problem.elo
	var odds = pow(10, eloDifference / 400.0)
	var winningOdds = odds / (odds + 1.0)
	return randf() < winningOdds

func successfulSolve() -> bool:
	var draggableCompetitors = workingPanel.objectsAttached
	assert(!draggableCompetitors.is_empty())

	var competitorElo = calculate_elo(draggableCompetitors)
	print("solve attempt")
	print(str(draggableCompetitors[0].competitor.elo) + " " + str(competitorElo))

	var eloDifference = competitorElo - problem.elo
	var odds = pow(10, eloDifference / 400.0)
	var winningOdds = odds / (odds + 1.0)

	return randf() < winningOdds

func blinkBar(nodeToBlink) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(nodeToBlink, "modulate:a", 0.0, 0.7)
	tween.tween_property(nodeToBlink, "modulate:a", 1.0, 0.7)
	tween.tween_property(nodeToBlink, "modulate:a", 0.0, 0.7)
	await tween.tween_property(nodeToBlink, "modulate:a", 1.0, 0.7).finished

func calculate_elo(draggableCompetitors: Array) -> float:
	var elos = []
	for draggableCompetitor in draggableCompetitors:
		elos.append(get_elo(draggableCompetitor.competitor))
	
	if elos.size() == 1:
		return elos[0]

	var average_elo: float = 0.0
	var average_elo_diff: float = 0.0
	var eloBoost: float = 1.0
	
	if elos.size() == 2:
		average_elo = (elos[0] + elos[1])/2.0
		average_elo_diff = abs(elos[0] - elos[1])/2.0
		eloBoost = 1.5
	else:
		average_elo = (elos[0] + elos[1] + elos[2])/3.0
		average_elo_diff = ( abs(elos[0] - elos[1]) + abs(elos[0] - elos[2])  + abs(elos[1] - elos[2]) ) /3.0
		eloBoost = 2.25
	
	var synergy = max(eloBoost - average_elo_diff / 750.0, 1.1)
	
	print("average_diff = ", average_elo_diff)
	print("elos = ", elos)
	print("final elo = ", average_elo * synergy)
	print("synergy = ", synergy)
	
	return average_elo * synergy


func get_elo(competitor: Competitor) -> float:
	var boost = 1.0
	
	for tag in problem.problemTags:
		if competitor.competences.has(tag):
			boost += competitor.competences[tag] * 0.015
	
	return competitor.elo * boost
