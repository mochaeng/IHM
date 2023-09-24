using Godot;

public partial class Wood : Entity
{

	public override void _Ready()
	{
		base._Ready();

		Interacted += () => InteractWith();
	}

	public void CompletedAction()
	{
		if (IsCompleted)
		{
			return;
		}
		EmitSignal("Completed");
		IsCompleted = true;
		QueueFree();
	}

	public void InteractWith()
	{
		AnimationPlayer.Play("blink");
		Selection.Visible = false;
	}
}