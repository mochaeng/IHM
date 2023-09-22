using Godot;

public partial class Block : Button
{
	[Signal]
	public delegate void BlockClickedEventHandler(Block block);

	[Export]
	public string Category = "";

	public override Variant _GetDragData(Vector2 atPosition)
	{
		var preview = (Control)this.Duplicate();
		SetDragPreview(preview);
		return this;
	}

	public override void _Pressed()
	{
		GD.Print("emitindo: " + Category);
		EmitSignal("BlockClicked", this);
	}

}
