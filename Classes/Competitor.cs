using Godot;
using System;
using System.Collections.Generic;

public partial class Competitor : Node
{
	public Competitor(List<(Auxiliary.TAGS, int)> competences, int elo)
	{
		Competences = competences;
		Elo = elo;
	}

	private List<(Auxiliary.TAGS, int)> Competences { get; set; }
	private int Elo { get; set; } = 0;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{

	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
