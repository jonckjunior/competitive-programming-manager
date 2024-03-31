using Godot;
using System;

public partial class out_contest_scene : Node2D
{
	private Button NextContest;

	[Signal]
	public delegate void StartTransitionToNextContestEventHandler();

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var NextContest = GetNode<Button>("Control/NextContestButton");
		NextContest.Pressed += GetNextContest;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	private void GetNextContest()
	{
		GD.Print("GET NEXT CONTEST");
		EmitSignal(SignalName.StartTransitionToNextContest);
	}
}
