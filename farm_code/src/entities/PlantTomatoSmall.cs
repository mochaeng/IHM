using Godot;
using System;

public partial class PlantTomatoSmall : Entity
{
	public override void _Ready()
	{
		base._Ready();
		Interacted += () => InteractWith();
	}

	public void CompletedAction()
	{
		if (IsCompleted)
		{
			return;
		}
		EmitSignal("Completed");
		IsCompleted = true;
	}

	public void InteractWith()
	{
		GD.Print("I WAS WATERED");
		AnimationPlayer.Play("blink");
		Sprite.Frame = 10;
		Selection.Visible = false;
	}
}
