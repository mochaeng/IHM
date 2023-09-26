using Godot;
using System;

public partial class SettingsWindow : CanvasLayer
{
	[Signal]
	public delegate void ShouldCloseSettingsEventHandler();

	public Button BackButton;

	public override void _Ready()
	{
		BackButton = GetNode<Button>("Control/Panel/BackButton");
		BackButton.Pressed += () => OnBackButtonPressed();
	}

	public void OnBackButtonPressed()
	{
		EmitSignal("ShouldCloseSettings");
	}

}
