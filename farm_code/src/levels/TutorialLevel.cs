using Godot;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;

public partial class TutorialLevel : NormalLevel
{
    public Dialogue Dialogue;
    public Button SkipButton;
    public Panel PanelBottom;

    public enum Stage { CONVERSATION_1, ACTION_1 }

    public List<Stage> StagesSequence;
    public int StageSequencePointer = 0;
    public bool IsSettingStage = false;
    public Stage CurrentStage;
    public string PathToDialogue;
    public List<string> TexturesPath;

    public override void _Ready()
    {
        base._Ready();
        Initiate();

        Dialogue = GetNode<Dialogue>("Dialogue");
        SkipButton = GetNode<Button>("SkipButton");
        PanelBottom = GetNode<Panel>("PanelBottom");

        Dialogue.ShouldChangeStage += () => OnDialogueShouldChangeStage();
        Dialogue.DialogueChange += () => OnDialogueChange();
        SkipButton.Pressed += () => OnSkiptButtonPressed();
    }

    public void SetConversation1()
    {
        EnableDialogueMode();
    }

    public void SetAction1()
    {
        DisableDialogueMode();
    }

    public void EnableDialogueMode()
    {
        Dialogue.Position = new Vector2(0, 42);
        SkipButton.Position = new Vector2(2, 107);
    }

    public void DisableDialogueMode()
    {
        Dialogue.Position = new Vector2(0, 200);
        SkipButton.Position = new Vector2(2, 200);
    }

    public void OnDialogueChange()
    {
        Dialogue.SetDialogue(Dialogue.GetCurrentDialogueLine());
    }

    public void OnDialogueShouldChangeStage()
    {
        StageSequencePointer += 1;
        if (StageSequencePointer >= StagesSequence.Count)
        {
            return;
        }
        IsSettingStage = true;
        CurrentStage = StagesSequence[StageSequencePointer];
    }

    public void OnSkiptButtonPressed()
    {
        Dialogue.NextDialogue();
    }
}
