using Godot;
using System;

public partial class W2Level1 : TutorialLevel
{

	public W2Level1()
	{
		StagesSequence = new() { Stage.CONVERSATION_1, Stage.ACTION_1 };
		CurrentStage = Stage.CONVERSATION_1;
		PathToDialogue = "res://art/resources/dialogues/w2_l1.json";
		TexturesPath = new() {
			"res://art/npcs/emylly_normal.png",
			"res://art/npcs/emylly_shy.png",
			"res://art/npcs/emylly_surprise.png",
			"res://art/npcs/emylly_helping.png"
		};
	}

	public override void _Ready()
	{
		base._Ready();

		Dialogue.Initiate(PathToDialogue, TexturesPath);
		Dialogue.SetDialogue(Dialogue.GetCurrentDialogueLine());
		// UpdateLabel();

		Dialogue.Visible = true;
	}

	public override void _Process(double delta)
	{
		switch (CurrentStage)
		{
			case Stage.CONVERSATION_1:
				if (IsSettingStage)
				{
					SetConversation1();
					IsSettingStage = false;
				}
				break;
			case Stage.ACTION_1:
				if (IsSettingStage)
				{
					SetAction1();
					IsSettingStage = false;
				}
				break;
		}
	}
	public override void CompletedLevel()
	{
		var singleton = GetNode<Singleton>("/root/Singleton");

		singleton.SetHasConcludePhase(1, 0, true);
		singleton.SetHasEnablePhase(1, 1, true);

		singleton.ChangeSceneWithTransition("W2_L2");
	}
}
