using Godot;
using System;
using System.Diagnostics;

public partial class main_scene_script : Node2D
{
	private Node2D OutContestScene;
	private Node2D InContestScene;

	public Manager CurrentManager { get; set; }

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		OutContestScene = GetNode<Node2D>("OutContestScene");
		InContestScene = GetNode<Node2D>("InContestScene");

		Debug.Assert(OutContestScene.HasSignal("StartTransitionToNextContest"));


		OutContestScene.StartTransitionToNextContest += TransitionToNextContest;


		OutContestScene.Visible = true;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public void TransitionToNextContest()
	{
		GD.Print("starting transition");
	}
}
