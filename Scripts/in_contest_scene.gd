extends Node2D
class_name InContestScene

@onready var balloonScene = load("res://Scenes/ac_balloon.tscn")

@export var timeToUpdateUI : float
@export var timeToUpdateStandings: float = 5.0
@export var competitor1: DraggableCompetitor
@export var competitor2: DraggableCompetitor
@export var competitor3: DraggableCompetitor

@onready var problemController: Node2D = $ProblemController
@onready var uiToUpdate : Array = get_tree().get_nodes_in_group("updateUI")
@onready var standingController : StandingController = $StandingPanel/ProblemHolder/ScrollContainer

var contest: Contest
var timeSinceUpdate: float
var competitorIsWorkingOn: Dictionary
var teamPosition: Dictionary
var problemStatusByTeam: Array
var teamProblemsAvailable: Array


var teamsStandings: Array[Manager]
var teamToProblemSolved: Dictionary

var timeSinceLastStandingUpdate = timeToUpdateStandings

func _ready():
	contest = Contest.new()
	var problems = problemController.get_children()
	contest.create_contest(10, problems.size())

	for i in range(problems.size()):
		var problemPane: MetalPanelProblem = problems[i]
		problemPane.problem = contest.problemSet[i]
		problemPane.problem_solved.connect(user_passed_problem)
	
	competitor1.competitor = contest.managers[0].activeCompetitors[0]
	competitor2.competitor = contest.managers[0].activeCompetitors[1]
	competitor3.competitor = contest.managers[0].activeCompetitors[2]

	for i in range(contest.managers.size()):
		var team: Manager = contest.managers[i]
		teamPosition[team.teamName] = i
		
		problemStatusByTeam.append([])
		teamProblemsAvailable.append(range(contest.problemSet.size()))
		teamToProblemSolved[team.teamName] = []
		
		for problem in contest.problemSet:
			problemStatusByTeam[i].append(Vector2(0.0, 0.0))
		
		for competitor in team.activeCompetitors:
			competitorIsWorkingOn[competitor.competitorId] = -1
	
	teamsStandings = contest.managers.duplicate(true)

func _process(delta):
	uiToUpdate = get_tree().get_nodes_in_group("updateUI")
	update_UI(delta)
	
	assign_problem_to_competitors()
	update_problem_progress(delta)
	update_standings(delta)
	highlight_problem_panel()

func update_UI(delta) -> void:
	timeSinceUpdate += delta
	if timeSinceUpdate > timeToUpdateUI:
		for ui in uiToUpdate:
			ui.frame = randi() % ui.sprite_frames.get_frame_count("default")
		timeSinceUpdate = 0.0

func assign_problem_to_competitors() -> void:
	for i in range(contest.managers.size()):
		# team 0 is user's
		if i == 0:
			continue
		var team = contest.managers[i]
		for j in range(3):
			var competitor: Competitor = team.activeCompetitors[j]
			if competitorIsWorkingOn[competitor.competitorId] != -1:
				continue
			
			var availableProblems: Array = teamProblemsAvailable[i]
			
			if availableProblems.is_empty():
				continue
			var pickedProblemNumber: int = availableProblems.pick_random()
			competitorIsWorkingOn[competitor.competitorId] = pickedProblemNumber
			teamProblemsAvailable[i].erase(pickedProblemNumber)

func update_problem_progress(delta) -> void:
	for i in range(contest.managers.size()):
		for j in range(contest.problemSet.size()):
			var currentlyWorking = []
			for competitor in contest.managers[i].activeCompetitors:
				if competitorIsWorkingOn[competitor.competitorId] == j:
					currentlyWorking.append(competitor)
			
			if currentlyWorking.is_empty():
				continue
			
			problemStatusByTeam[i][j][0] += delta / 2.0
			
			var timeBase = getTimeBase(contest.problemSet[j], problemStatusByTeam[i][j][1])
			
			if problemStatusByTeam[i][j][0] >= timeBase:
				problemStatusByTeam[i][j][0] = 0.0
				if successfulAttempt(currentlyWorking[0], contest.problemSet[j]):
					problemStatusByTeam[i][j][1] += 1
					if problemStatusByTeam[i][j][1] >= 3:
						pass_problem(i, j, currentlyWorking)
				else:
					print("bot falhou no problema " + str(j) )

func getTimeBase(problem: Problem, status: int) -> float:
	if status == 0:
		return problem.readingTimeBase
	elif status == 1:
		return problem.solvingTimeBase
	else:
		return problem.codingTimeBase

func successfulAttempt(competitor: Competitor, problem: Problem) -> bool:
	var boost = 1.0
	for tag in problem.problemTags:
		if competitor.competences.has(tag):
			boost += competitor.competences[tag] * 0.015

	var eloDifference = competitor.elo * boost - problem.elo
	var odds = pow(10, eloDifference / 400.0)
	var winningOdds = odds / (odds + 1.0)

	return randf() < winningOdds

func pass_problem(teamNumber: int, problemNumber: int, competitors: Array) -> void:
	teamProblemsAvailable[teamNumber].erase(problemNumber)
	teamToProblemSolved[contest.managers[teamNumber].teamName].append(problemNumber)
	print(str(teamNumber) + " passou o problema " + str(problemNumber))
	for competitor in competitors:
		competitorIsWorkingOn[competitor.competitorId] = -1

func update_standings(delta) -> void:
	timeSinceLastStandingUpdate += delta
	
	if timeSinceLastStandingUpdate >= timeToUpdateStandings:
		teamsStandings.sort_custom(compare_teams)
		
		standingController.teams = teamsStandings
		standingController.teamToProblemSolved = teamToProblemSolved
		standingController.render_standings(contest.managers[0].teamName)
		
		timeSinceLastStandingUpdate = 0.0

func compare_teams(a: Manager, b: Manager) -> bool:
	var problems_solved_a = teamToProblemSolved[a.teamName].size()
	var problems_solved_b = teamToProblemSolved[b.teamName].size()
	if problems_solved_a > problems_solved_b:
		return true  # A comes before B
	elif problems_solved_a < problems_solved_b:
		return false  # B comes before A
	
	# If the number of problems solved is the same, compare by team name
	if a.teamName < b.teamName:
		return true  # A comes before B alphabetically
	elif a.teamName > b.teamName:
		return false  # B comes before A alphabetically
	
	return true

func user_passed_problem(problemNumber: int):
	pass_problem(0, problemNumber, [])
	var problemPanel = problemController.get_children()[problemNumber]
	var balloonPosition = problemPanel.acBalloonPositionMarker.global_position
	var balloonScene = balloonScene.instantiate()
	balloonScene.global_position = balloonPosition
	add_child(balloonScene)
	
	get_tree().create_tween().tween_property(balloonScene, "global_position:y", balloonScene.global_position.y - 100, 5.0)
	get_tree().create_tween().tween_property(balloonScene, "modulate:a", 0, 5.0)

func highlight_problem_panel() -> void:
	var shouldTurnItOff = competitor1.is_dragging == false and competitor2.is_dragging == false and competitor3.is_dragging == false
	for problemPanel in problemController.get_children():
		if shouldTurnItOff:
			(problemPanel.problemSheet.material as ShaderMaterial).set_shader_parameter("width", 0.0)
		else:
			(problemPanel.problemSheet.material as ShaderMaterial).set_shader_parameter("width", 3.0)
