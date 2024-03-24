using Godot;
using System;
using System.Collections.Generic;

public partial class Manager : Node
{
	public Manager(List<Competitor> competitors, int funds, string teamName)
	{
		Competitors = competitors;
		Funds = funds;
		TeamName = teamName;
	}

	public List<Competitor> Competitors { get; set; }
	public int Funds { get; set; }
	public String TeamName { get; set; }

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
