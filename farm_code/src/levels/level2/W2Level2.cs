using Godot;
using System;

public partial class W2Level2 : NormalLevel
{
	public override void _Ready()
	{
		base._Ready();
		Initiate();
	}
	public override void CompletedLevel()
	{
		var singleton = GetNode<Singleton>("/root/Singleton");

		singleton.SetHasConcludePhase(1, 1, true);
		singleton.SetHasConcludeWorld(1, true);
		singleton.SetHasEnablePhase(2, 0, true);
		singleton.SetHasEnableWorld(2, true);

		singleton.ChangeSceneWithTransition("WorldsSelection");
	}
}
