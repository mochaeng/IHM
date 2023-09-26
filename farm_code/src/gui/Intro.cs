using Godot;
using System;

public partial class Intro : Control
{

	public AnimationPlayer AnimationPlayer;

	public override async void _Ready()
	{
		AnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		AnimationPlayer.Play("fade_in");
		await ToSignal(AnimationPlayer, "animation_finished");
		AnimationPlayer.Play("fade_out");
		await ToSignal(AnimationPlayer, "animation_finished");

		var singleton = GetNode<Singleton>("/root/Singleton");
		singleton.ChangeSceneWithTransition("MenuScreen");
	}

}
