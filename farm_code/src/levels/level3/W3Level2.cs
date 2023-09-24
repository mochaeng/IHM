using Godot;
using System;

public partial class W3Level2 : NormalLevel
{
    public override void _Ready()
    {
        base._Ready();
        Initiate();
    }

    public override void CompletedLevel()
    {
        var singleton = GetNode<Singleton>("/root/Singleton");

        singleton.SetHasConcludePhase(2, 1, true);
        singleton.SetHasConcludeWorld(2, true);

        singleton.ChangeSceneWithTransition("WorldsSelection");
    }
}