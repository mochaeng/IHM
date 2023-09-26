using Godot;
using System;

public partial class Instructions : Control
{
	public override void _Ready()
	{
		GetNode<Button>("BackButton").Pressed += () => OnBackButtonPressed();
		GetNode<Button>("YtButton").Pressed += () => OnYtButtonPressed();
	}

	public void OnYtButtonPressed()
	{
		OS.ShellOpen("https://youtu.be/UdJ2T_Ygqg0");
	}

	public void OnBackButtonPressed()
	{
		GetNode<Singleton>("/root/Singleton").ChangeSceneWithTransition("MenuScreen");
	}

}
