using Godot;
using System;

public partial class W3Level1 : NormalLevel
{
    public override void _Ready()
    {
        base._Ready();
        Initiate();
    }

    public override void CompletedLevel()
    {
        var singleton = GetNode<Singleton>("/root/Singleton");

        singleton.SetHasConcludePhase(2, 0, true);
        singleton.SetHasEnablePhase(2, 1, true);

        singleton.ChangeSceneWithTransition("W3_L2");
    }
}