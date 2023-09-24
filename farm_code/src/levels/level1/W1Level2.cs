using Godot;
using System;

public partial class W1Level2 : NormalLevel
{
	public override void _Ready()
	{
		base._Ready();
		Initiate();
	}

	public override void CompletedLevel()
	{
		var singleton = GetNode<Singleton>("/root/Singleton");

		singleton.SetHasConcludePhase(0, 1, true);
		singleton.SetHasEnablePhase(0, 2, true);

		singleton.ChangeSceneWithTransition("W1_L3");
	}

}
