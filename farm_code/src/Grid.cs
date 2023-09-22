using Godot;

public partial class Grid : Node2D
{
	public override void _Draw()
	{
		var constants = GetNode<Singleton>("/root/Singleton");

		for (int i = 0; i < constants.CellsAmount.X; i++)
		{
			var from = new Vector2(i * constants.CellSize.X, 0);
			var to = new Vector2(from.X, constants.GridSize.Y);
			DrawLine(from, to, constants.Black);
		}

		for (int i = 0; i < constants.CellsAmount.Y; i++) {
			var from = new Vector2(0, constants.CellSize.Y * i);
			var to = new Vector2(constants.GridSize.X, from.Y);
			DrawLine(from, to, constants.Black);
		}
	}
}
