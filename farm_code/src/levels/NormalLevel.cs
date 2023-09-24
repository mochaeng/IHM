using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class NormalLevel : Node2D
{
    [Signal]
    public delegate void CleanPanelEventHandler();

    public Player Player;
    public Label LabelText;
    public List<Entity> Entities;
    public int TotalAmount;
    public PanelQueue PanelQueue;
    public Panel RightPanel;

    public const int MAXIMUM_BLOCKS = 9;
    public int EntitiesCompleted = 0;
    public bool IsProcessingCommands = false;
    public List<String> Commands = new();

    public Button PlayButton;
    public Button CleanButton;

    public override void _Ready()
    {
        Player = GetNode<Player>("Player");
        LabelText = GetNode<Label>("MissionIndicator/Label");
        PanelQueue = GetNode<PanelQueue>("PanelBottom/PanelQueue");
        RightPanel = GetNode<Panel>("RightPanel");
        PlayButton = GetNode<Button>("PanelBottom/PlayButton");
        CleanButton = GetNode<Button>("PanelBottom/CleanButton");

        Entities = GetNode<Node2D>("Entities").GetChildren()
            .Where(child => child is Entity)
            .Cast<Entity>()
            .ToList();
        TotalAmount = Entities.Count;

        PanelQueue.BlockAdded += (data) => OnPanelQueueBlockAdded(data);
        PlayButton.Pressed += () => OnPlayButtonPressed();
        CleanButton.Pressed += () => OnCleanButtonPressed();

        foreach (var entity in Entities)
        {
            entity.Completed += () => OnEntityCompleted();
        }
        // Initiate();
    }

    public override void _Process(double delta)
    {
        if (PanelQueue.BlocksInside.Count > 9)
        {
            var idx = Commands.Count - 1;
            Commands.RemoveAt(idx);
            PanelQueue.EmitSignal("LastBlockDeleted");
        }
    }

    public void Initiate()
    {
        UpdateLabel();
        var items = RightPanel.GetChildren();
        foreach (var item in items)
        {
            var block = (Block)item;
            block.BlockClicked += (block) => AddBlockCommand(block);
        }
    }

    public void AddBlockCommand(Block block)
    {
        GD.Print("Recebi o sinal: " + block.Category);
        if (Commands.Count >= 9)
        {
            return;
        }
        PanelQueue.AddBlockVisually(block);
    }

    public void UpdateLabel()
    {
        LabelText.Text = $"{EntitiesCompleted}/{TotalAmount}";
    }

    public async void ProcessCommands()
    {
        IsProcessingCommands = true;

        BeforeProcessingCommands();
        foreach (var dir in Commands)
        {
            GD.Print(dir);
            Player.MoveByDirection(dir);
            await ToSignal(GetTree().CreateTimer(1), "timeout");
        }
        await ToSignal(GetTree().CreateTimer(0.3), "timeout");
        AfterProcessingCommands();

        if (EntitiesCompleted != TotalAmount)
        {
            Player.EmitSignal("SadEmoted");
            await ToSignal(Player, "SadEmoted");
            GetTree().ReloadCurrentScene();
        }
        else
        {
            CompletedLevel();
        }

        IsProcessingCommands = false;

    }

    public void OnEntityCompleted()
    {
        if (EntitiesCompleted <= TotalAmount)
        {
            EntitiesCompleted += 1;
            UpdateLabel();
        }
    }

    public void OnPanelQueueBlockAdded(Block data)
    {
        GD.Print("TENTOU ADICIONAR BLOCO");
        if (Commands.Count >= 9)
        {
            return;
        }
        Commands.Add(data.Category);
    }

    public void OnPlayButtonPressed()
    {
        GD.Print(Commands);
        if (!IsProcessingCommands)
        {
            ProcessCommands();
        }
    }

    public void OnCleanButtonPressed()
    {
        if (!IsProcessingCommands)
        {
            var idx = Commands.Count - 1;
            if (idx < 0)
            {
                return;
            }
            Commands.RemoveAt(idx);
            PanelQueue.EmitSignal("LastBlockDeleted");
        }
    }

    public void BeforeProcessingCommands() { }
    public void AfterProcessingCommands() { }
    public void CompletedLevel() { }
    public void NotCompletedLebel() { }
}