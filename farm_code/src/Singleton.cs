using Godot;
using System;
using System.Collections.Generic;


public partial class Singleton : Node
{
    public Vector2 GridSize;
    public Vector2 CellSize;
    public Vector2 CellsAmount;

    public Color Black = new("23213D");
    public Color Gray = new("B9B5C3");

    public Boolean IsSongsEnable = false;

    // public override void _Ready()
    // {
    //     GridSize = new(800, 600);
    //     CellSize = new(16, 16);
    //     CellsAmount = new(GridSize.X / CellSize.X, GridSize.Y / CellSize.Y);
    // }

    public Dictionary<String, String> ScenesPath;

    public Texture ArrowCursor;

    public Texture PointingHandCursor;
    public Texture HoldingCursor;

    public CanvasLayer Transitioner;

    public CanvasLayer SettingsWindow;

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
    }
}
