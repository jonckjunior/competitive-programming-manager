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

func create_contest(numberOfTeams: int, numberOfProblems: int) -> void:
	
	var averageElo = 1500
	var deviationElo = 300
	
	var averageReading = 1
	var deviationReading = 4
	
	var averageSolving = 1
	var deviationSolving = 2
	
	var averageCoding = 1
	var deviationCoding = 3
	
	for i in range(numberOfProblems):
		var problem = Problem.new()
		problem.elo = randfn(averageElo, deviationElo)
		problem.readingTimeBase = max(randfn(averageReading, deviationReading), 1.0)
		problem.solvingTimeBase = max(randfn(averageSolving, deviationSolving), 1.0)
		problem.codingTimeBase = max(randfn(averageCoding, deviationCoding), 1.0)
		problem.problemDescription = "This is a very complicated problem."
		problem.problemName = "A difficult problem."
		problem.problemNumber = i
		problem.problemTags = Auxiliary.TAGS
		
		problemSet.append(problem)
	
	var teamNames = [
		"CodeBusters",
		"Bit Please",
		"Runtime Terror",
		"Infinite Loop Troopers",
		"Stack Overflowers",
		"The Codinators",
		"Null Pointers",
		"Recursive Nightmares",
		"Bug Hunters",
		"Array of Sunshine",
		"The Exception Handlers",
		"Git Push Force",
		"Boolean Barbarians",
		"The Debugging Demons",
		"Variable Vagabonds",
		"Breakpoint Bandits",
		"Threading The Needle",
		"Code Crusaders",
		"Algorithm Avengers",
		"Binary Blazers",
		"Data Dynamos",
		"Syntax Soldiers",
		"Runtime Raiders",
		"Loop Legends",
		"Variable Vikings",
		"Function Fighters",
		"Stack Saviors",
		"Heap Heroes",
		"Logic Lancers",
		"Array Aces",
		"Recursion Rangers",
		"Bitwise Bandits",
		"Compile Commanders",
		"Memory Mavericks",
		"Process Pioneers",
		"Buffer Battlers",
		"Thread Thrivers"
	]
	
	teamNames.shuffle()
	
	for i in range(numberOfTeams):
		var team = Manager.new()
		team.teamName = "TEAM " + str(i)
		team.myFunds = i * 100
		for j in range(3):
			var competitor = Competitor.new()
			competitor.elo = randfn(averageElo, deviationElo)
			competitor.competitorId = i * 3 + j
			for tag in Auxiliary.TAGS:
				competitor.competences[tag] = 0
			team.myCompetitors.append(competitor)
			team.teamName = (teamNames[i] as String).to_lower()
		team.activeCompetitors = team.myCompetitors
		managers.append(team)

