using Godot;
using System.Collections.Generic;
using System.Linq;

public partial class PhasesSelection3 : Control
{
	public List<Button> Buttons;
	public Singleton Singleton;
	public Button BackButton;

	public override void _Ready()
	{
		Singleton = GetNode<Singleton>("/root/Singleton");

		Buttons = GetNode<Control>("Buttons").GetChildren()
			.Cast<Button>()
			.ToList();

		Singleton.ProcessedPhaseButtons(
			Buttons, Singleton.GetPhasesEnable(2), Singleton.GetPhasesConclude(2)
		);

		BackButton = GetNode<Button>("BackButton");
		BackButton.Pressed += () => OnBackButtonPressed();

		Buttons[0].Pressed += () => OnPhase1Pressed();
		Buttons[1].Pressed += () => OnPhase2Pressed();
	}

	public void OnBackButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("WorldsSelection");
	}

	public void OnPhase1Pressed()
	{
		Singleton.ChangeSceneWithTransition("W3_L1");
	}

	public void OnPhase2Pressed()
	{
		Singleton.ChangeSceneWithTransition("W3_L2");
	}

}
