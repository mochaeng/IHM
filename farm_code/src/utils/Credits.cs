using Godot;
using System;

public partial class Credits : Control
{
	public override void _Ready()
	{
		GetNode<Button>("GitButton").Pressed += () => OnGitButtonPressed();
		GetNode<Button>("BackButton").Pressed += () => OnBackButtonPressed();
	}

	public void OnGitButtonPressed()
	{
		OS.ShellOpen("https://github.com/mochaeng/IHM");
	}
	public void OnBackButtonPressed()
	{
		GetNode<Singleton>("/root/Singleton").ChangeSceneWithTransition("MenuScreen");
	}

}
