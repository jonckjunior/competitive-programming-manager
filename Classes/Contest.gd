extends Node
class_name Contest

class ScoreByProblem:
	var solvedByTeam: Array[String]
	var numberOfAttemptsByTeam: Dictionary

var managers: Array[Manager]
var problemSet: Array[Problem]
var scoreBoard: Array[ScoreByProblem]

func read_problem(competitor : Competitor, problemNumber: int) -> int:
	assert_problem_number_is_good(problemNumber)
	return problemSet[problemNumber].readingTimeBase

func solve_problem(competitor : Competitor, problemNumber: int) -> int:
	assert_problem_number_is_good(problemNumber)
	return problemSet[problemNumber].solvingTimeBase
	
func code_problem(competitor : Competitor, problemNumber: int) -> int:
	assert_problem_number_is_good(problemNumber)
	return problemSet[problemNumber].codingTimeBase

func assert_problem_number_is_good(problemNumber: int) -> void:
	assert(0 <= problemNumber and problemNumber < problemSet.size())

func create_contest(numberOfTeams: int) -> void:
	var numberOfProblems: int = 16
	for i in range(numberOfProblems):
		var problem = Problem.new()
		problem.elo = i * 200
		#print(Auxiliary.TAGS.BASIC)
		#problem.problemTags = [ Auxiliary.TAGS.BASIC ]
		problem.readingTimeBase = i * 2
		problem.solvingTimeBase = i * 3
		problem.codingTimeBase = i * 2
		problem.problemDescription = "This is a very complicated problem."
		problem.problemName = "A difficult problem."
		problem.problemNumber = i
		
		problemSet.append(problem)
	
	for i in range(numberOfTeams):
		var team = Manager.new()
		team.teamName = "TEAM " + str(i)
		team.myFunds = i * 100
		for j in range(3):
			var competitor = Competitor.new()
			competitor.elo = randi_range(1000, 1500)
			#competitor.competences = [ Auxiliary.TAGS.BASIC ]
			team.myCompetitors.append(competitor)
		team.activeCompetitors = team.myCompetitors
		managers.append(team)

