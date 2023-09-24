using Godot;

public partial class Entity : StaticBody2D
{
    [Signal]
    public delegate void InteractedEventHandler();

    [Signal]
    public delegate void CompletedEventHandler();

    public AnimationPlayer AnimationPlayer;
    public Sprite2D Sprite;
    public AnimatedSprite2D Selection;
    public bool IsCompleted = false;

    public override void _Ready()
    {
        AnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        Sprite = GetNode<Sprite2D>("Sprite2D");
        Selection = GetNode<AnimatedSprite2D>("BlinkSelection");
    }
}