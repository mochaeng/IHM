using Godot;
using System;

public partial class HomeButton : Button
{

    public override void _Pressed()
    {	
		var singleton = GetNode<Singleton>("/root/Singleton");
		singleton.ChangeSceneWithTransition("WorldsSelection");
    }
}
