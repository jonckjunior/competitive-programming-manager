using Godot;
using System;
using System.Collections.Generic;
using System.Runtime.ConstrainedExecution;

public partial class Problem : Node
{
	public int Elo { get; set; }
	public List<Auxiliary.TAGS> ProblemTags { get; set; }
	public int ReadingTimeBase { get; set; }
	public int SolvingTimeBase { get; set; }
	public int CodingTimeBase { get; set; }

	public Problem(int elo, List<Auxiliary.TAGS> problemTags, int readingTimeBase, int solvingTimeBase, int codingTimeBase)
	{
		Elo = elo;
		ProblemTags = problemTags;
		ReadingTimeBase = readingTimeBase;
		SolvingTimeBase = solvingTimeBase;
		CodingTimeBase = codingTimeBase;
	}
}
