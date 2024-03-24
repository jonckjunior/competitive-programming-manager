using Godot;
using System;
using System.Linq;

public partial class TestScene : Control
{
	public Contest Contest = new();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		for (int i = 0; i < 3; i++)
		{
			GetNode<Button>($"Button{i + 1}").Pressed += AttemptToRead;
		}

		for (int i = 3; i < 6; i++)
		{
			GetNode<Button>($"Button{i + 1}").Pressed += AttemptToSolve;
		}

		for (int i = 6; i < 9; i++)
		{
			GetNode<Button>($"Button{i + 1}").Pressed += AttemptToCode;
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void AttemptToRead()
	{
		GD.Print(Contest.ReadProblem(Contest.Competitors.FirstOrDefault().Competitors.FirstOrDefault(), 2));
	}

	public void AttemptToSolve()
	{
		GD.Print(Contest.SolveProblem(Contest.Competitors.FirstOrDefault().Competitors.FirstOrDefault(), 2));
	}

	public void AttemptToCode()
	{
		GD.Print(Contest.CodeProblem(Contest.Competitors.FirstOrDefault().Competitors.FirstOrDefault(), 2));
	}
}
