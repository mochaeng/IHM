using Godot;
using System;

public partial class W1Level3 : NormalLevel
{
	public override void _Ready()
	{
		base._Ready();
		Initiate();
	}

	public override void CompletedLevel()
	{
		var singleton = GetNode<Singleton>("/root/Singleton");

		singleton.SetHasConcludePhase(0, 2, true);
		singleton.SetHasEnablePhase(1, 0, true);
		singleton.SetHasConcludeWorld(0, true);
		singleton.SetHasEnableWorld(1, true);

		singleton.ChangeSceneWithTransition("WorldsSelection");
	}
}
