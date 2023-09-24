using Godot;
using System;
using System.Collections;

public partial class PanelQueue : Panel
{
	[Signal]
	public delegate void BlockAddedEventHandler(Block data);

	[Signal]
	public delegate void PanelClenedEventHandler();

	[Signal]
	public delegate void LastBlockDeletedEventHandler();

	public ArrayList BlocksInside = new();

	public PackedScene DemoBlock;

	public override void _Ready()
	{
		DemoBlock = (PackedScene)ResourceLoader.Load("res://scenes/blocks/block.tscn");
		Connect("PanelClened", Callable.From(CleanPanel));
		Connect("LastBlockDeleted", Callable.From(DeleteLastBlock));
	}

	public override Variant _GetDragData(Vector2 atPosition)
	{
		var preview = this;
		SetDragPreview(preview);
		return preview;
	}

	public override bool _CanDropData(Vector2 atPosition, Variant data)
	{
		var block = data.Obj as Block;
		return block is not null && block?.Category != "";
	}

	public override void _DropData(Vector2 atPosition, Variant data)
	{
		var block = data.Obj as Block;
		if (block is null)
		{
			return;
		}

		var newBlock = CreatingBlock(block);
		AddToPanel(newBlock);
	}

	private Block CreatingBlock(Block data)
	{
		var newBlock = data.Duplicate() as Block;
		newBlock.GetNode<Sprite2D>("image").Centered = true;
		newBlock.CustomMinimumSize = new Vector2(64f, 64f);
		newBlock.GetNode<Sprite2D>("image").Position = new Vector2(32f, 32f);

		if (data.Category == "water" || data.Category == "axing")
		{
			newBlock.GetNode<Sprite2D>("image").Scale = new Vector2(3.8f, 3.95f);
		}
		else
		{
			newBlock.GetNode<Sprite2D>("image").Scale = new Vector2(0.2f, 0.2f);
		}

		return newBlock;
	}

	public void AddBlockVisually(Block blockToAdd)
	{
		var newBlock = CreatingBlock(blockToAdd);
		AddToPanel(newBlock);
	}

	public void AddToPanel(Block blockToAdd)
	{
		var container = GetNode<HBoxContainer>("Container");
		container.AddChild(blockToAdd);
		BlocksInside.Add(blockToAdd);
		EmitSignal("BlockAdded", blockToAdd);
	}

	private void CleanPanel()
	{
		var container = GetNode<HBoxContainer>("Container");
		var blocks = container.GetChildren();
		foreach (var block in blocks)
		{
			container.RemoveChild(block);
			block.CallDeferred("queue_free");
		}
	}

	private void DeleteLastBlock()
	{
		var idx = BlocksInside.Count - 1;
		if (idx < 0)
		{
			return;
		}

		var blockToRemove = BlocksInside[idx] as Block;
		blockToRemove?.CallDeferred("queue_free");
		BlocksInside.RemoveAt(idx);
	}
}
