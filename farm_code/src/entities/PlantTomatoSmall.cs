using Godot;
using System;

public partial class PlantTomatoSmall : StaticBody2D
{
	[Signal]
	public delegate void InteractedEventHandler();

	[Signal]
	public delegate void CompletedEventHandler();

	public AnimationPlayer AnimationPlayer;
	public Sprite2D Sprite;
	public AnimatedSprite2D Selection;

	public override void _Ready()
	{
		AnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		Sprite = GetNode<Sprite2D>("Sprite2D");
		Selection = GetNode<AnimatedSprite2D>("BlinkSelection");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
