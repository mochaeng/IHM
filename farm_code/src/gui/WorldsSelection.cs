using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class WorldsSelection : Panel
{
	public List<Panel> Worlds;
	public Singleton Singleton;

	public override void _Ready()
	{
		Singleton = GetNode<Singleton>("/root/Singleton");

		Worlds = GetNode<Control>("Worlds").GetChildren()
			.Cast<Panel>()
			.ToList();

		GetNode<Button>("BackButton").Pressed += () => OnBackButtonPressed();

		var idx = 0;
		foreach (var world in Worlds)
		{
			world.GetNode<Label>("Name").Text = $"Mundo {idx + 1}";

			var amountConclude = Singleton.GetAmountPhasesConcludeFromWorld(idx);

			world.GetNode<Label>("Quantity").Text = $"{amountConclude}/{Singleton.GetPhasesConclude(idx).Count}";

			if (!Singleton.IsWorldEnable(idx))
			{
				world.GetNode<Button>("PlayButton").Disabled = true;
				world.GetNode<Button>("PlayButton").Text = "";

				world.GetNode<Button>("InfoButton").Disabled = true;
				world.GetNode<Button>("InfoButton").Text = "";

				world.GetNode<Label>("Name").Visible = false;
				world.GetNode<Sprite2D>("Logo").Visible = false;
			}

			idx++;
		}

		Worlds[1].GetNode<Sprite2D>("Logo").Frame = 0;
		Worlds[2].GetNode<Sprite2D>("Logo").Frame = 3;

		Worlds[0].GetNode<Button>("PlayButton").Pressed += () => OnWorld1ButtonPressed();
		Worlds[1].GetNode<Button>("PlayButton").Pressed += () => OnWorld2ButtonPressed();
		Worlds[2].GetNode<Button>("PlayButton").Pressed += () => OnWorld3ButtonPressed();

	}

	public void OnBackButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("MenuScreen");
	}

	public void OnWorld1ButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("Phases_1_Selection");
	}

	public void OnWorld2ButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("Phases_2_Selection");
	}

	public void OnWorld3ButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("Phases_3_Selection");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
