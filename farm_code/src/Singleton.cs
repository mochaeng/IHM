using Godot;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;


public partial class Singleton : Node
{
    public Vector2 GridSize;
    public Vector2 CellSize;
    public Vector2 CellsAmount;

    public Color Black = new("23213D");
    public Color Gray = new("B9B5C3");

    public bool IsSongsEnable = false;

    public Dictionary<string, string> ScenesPath;

    public Texture ArrowCursor;
    public Texture PointingHandCursor;
    public Texture HoldingCursor;

    public CanvasLayer Transitioner;
    public CanvasLayer SettingsWindow;

    public const int ENABLED_START_FRAME = 7;
    public const int DISABLED_START_FRAME = 9;

    public List<bool> DialoguesShowed = new() { false, false, false };
    private List<List<bool>> PhasesConcluded = new() {
        new List<bool>() { false, false, false },
        new List<bool>() { false, false },
        new List<bool>() { false, false },
    };
    private List<List<bool>> PhasesEnable = new() {
        new List<bool>() { true, false, false },
        new List<bool>() { false, false },
        new List<bool>() { false, false },
    };
    private List<bool> WorldsConcluded = new() { false, false, false };
    private List<bool> WorldsEnable = new() { true, false, false };

    public override void _Ready()
    {
        GridSize = new(800, 600);
        CellSize = new(16, 16);
        CellsAmount = new(GridSize.X / CellSize.X, GridSize.Y / CellSize.Y);

        ArrowCursor = ResourceLoader.Load<Texture>(
            "res://art/cat_UI/Sprite sheets/Mouse sprites/Triangle Mouse icon 1.png"
        );
        PointingHandCursor = ResourceLoader.Load<Texture>(
            "res://art/cat_UI/Sprite sheets/Mouse sprites/Catpaw pointing Mouse icon.png"
        );
        HoldingCursor = ResourceLoader.Load<Texture>(
            "res://art/cat_UI/Sprite sheets/Mouse sprites/Catpaw holding Mouse icon.png"
        );
        Transitioner = ResourceLoader.Load<CanvasLayer>("res://scenes/gui/transitioner.tscn");
        SettingsWindow = ResourceLoader.Load<CanvasLayer>("res://scenes/gui/settings_window.tscn");

        ScenesPath = new() {
                {"WorldsSelection", "res://scenes/gui/new_worlds_selection.tscn"},
                {"MenuScreen", "res://scenes/gui/menu_screen.tscn"},
                {"Instructions", "res://scenes/tutorial/instructions.tscn"},
                {"Credits", "res://scenes/credits.tscn"},
                {"History_1", "res://scenes/tutorial/levels/tutorial1.tscn"},
                {"Phase1", "res://scenes/levels/level1.tscn"},
                {"Phase2", "res://scenes/levels/level2.tscn"},
                {"Phases_1_Selection", "res://scenes/gui/phases_selection_1.tscn"},
                {"Phases_2_Selection", "res://scenes/gui/phases_selection_2.tscn"},
                {"Phases_3_Selection", "res://scenes/gui/phases_selection_3.tscn"},
                {"W1_L1", "res://scenes/levels/world1/w1_level1.tscn"},
                {"W1_L2", "res://scenes/levels/world1/w1_level2.tscn"},
                {"W1_L3", "res://scenes/levels/world1/w1_level3.tscn"},
                {"W2_L1", "res://scenes/levels/world2/w2_level1.tscn"},
                {"W2_L2", "res://scenes/levels/world2/w2_level2.tscn"},
                {"W3_L1", "res://scenes/levels/world3/w3_level1.tscn"},
                {"W3_L2", "res://scenes/levels/world3/w3_level2.tscn"},
            };

        Input.SetCustomMouseCursor(ArrowCursor);
        Input.SetCustomMouseCursor(PointingHandCursor, Input.CursorShape.PointingHand);
        Input.SetCustomMouseCursor(ArrowCursor, Input.CursorShape.Forbidden);
        Input.SetCustomMouseCursor(HoldingCursor, Input.CursorShape.CanDrop);
    }

    public async void ChangeSceneWithTransition(string target)
    {
        var transitionerInstance = Transitioner.Duplicate() as CanvasLayer;
        var animationPlayer = Transitioner.GetNode<AnimationPlayer>("AnimationPlayer");

        // await ToSignal(GetTree().Root.CallDeferred("add_child", transitionerInstance), "add_child");
        GetTree().Root.Call("add_child", transitionerInstance);

        animationPlayer.Play("fade_out");
        await ToSignal(animationPlayer, "AnimationFinished");

        if (ScenesPath.ContainsKey(target))
        {
            target = ScenesPath[target];
        }

        GetTree().ChangeSceneToFile(target);

        animationPlayer.Play("fade_in");
        await ToSignal(animationPlayer, "AnimationFinished");

        GetTree().Root.CallDeferred("remove_child", transitionerInstance);
        transitionerInstance.CallDeferred("queue_free");
        animationPlayer.CallDeferred("queue_free");
    }

    public void ProcessedPhaseButtons(Array buttons)
    {
        var idx = 0;
        foreach (var hasEnable in PhasesEnable)
        {
            
        }
    }

    public int GetPhasesConcludeFromWorld(int world)
    {
        var quantity = 0;
        foreach (var hasCompleted in PhasesConcluded[world])
        {
            if (hasCompleted)
            {
                quantity += 1;
            }
        }
        return quantity;
    }
    public void SetHasShowedDialogues(int dialogue, bool isValue)
    {
        DialoguesShowed[dialogue] = isValue;
    }

    public void SetHasConcludePhase(int world, int phase, bool isValue)
    {
        PhasesConcluded[world][phase] = isValue;
    }

    public void SetHasEnablePhase(int world, int phase, bool isValue)
    {
        PhasesEnable[world][phase] = isValue;
    }

    public void SetHasConcludeWorld(int world, bool isValue)
    {
        WorldsConcluded[world] = isValue;
    }

    public void SetHasEnableWorld(int world, bool isValue)
    {
        WorldsEnable[world] = isValue;
    }

    public void SetIsSongsEnable(bool isValue)
    {
        IsSongsEnable = isValue;
    }

}
