using Godot;
using System;
using System.Collections.Generic;

public partial class Contest : Node
{
	public Contest()
	{
		_Ready();
	}

	public List<Problem> ProblemSet { get; set; } = new();

	public List<Manager> Competitors { get; set; } = new();

	public List<ScoreByProblem> ScoreBoard { get; set; } = new();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		for (int i = 0; i < 15; i++)
		{
			ProblemSet.Add(
				new Problem(
					elo: i * 100,
					problemTags: new List<Auxiliary.TAGS> { Auxiliary.TAGS.MATH },
					readingTimeBase: i * 2,
					solvingTimeBase: i,
					codingTimeBase: i
				)
			);
		}

		Competitor competitor = new(competences: new List<(Auxiliary.TAGS, int)>(), elo: 1500);
		Competitors.Add(
			new Manager(
				competitors: new List<Competitor> { competitor },
				funds: 1000,
				teamName: "udescao"
			)
		);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public int ReadProblem(Competitor competitor, int problemNumber) => ProblemSet[problemNumber].ReadingTimeBase;
	public int SolveProblem(Competitor competitor, int problemNumber) => ProblemSet[problemNumber].SolvingTimeBase;
	public int CodeProblem(Competitor competitor, int problemNumber) => ProblemSet[problemNumber].CodingTimeBase;

	public class ScoreByProblem
	{
		public List<string> SolvedByTeam { get; set; }
		public Dictionary<string, int> NumbefOfAttemptsByTeam { get; set; }
	}
}
