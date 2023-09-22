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

	public override void _Ready()
	{
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
		var newBlock = new Block
		{
			Position = new Vector2(500, 5)
		};

		// var image = newBlock.GetNode<Sprite2D>("image");
		// image.Texture = data.GetNode<Sprite2D>("image").Texture;
		// image.Hframes = data.GetNode<Sprite2D>("image").Hframes;
		// image.Vframes = data.GetNode<Sprite2D>("image").Vframes;

		newBlock.GetNode<Sprite2D>("image").Texture = data.GetNode<Sprite2D>("image").Texture;
		newBlock.GetNode<Sprite2D>("image").Hframes = data.GetNode<Sprite2D>("image").Hframes;
		newBlock.GetNode<Sprite2D>("image").Vframes = data.GetNode<Sprite2D>("image").Vframes;
		newBlock.GetNode<Sprite2D>("image").Frame = data.GetNode<Sprite2D>("image").Frame;
		newBlock.Category = data.Category;
		newBlock.CustomMinimumSize = new Vector2(64f, 64f);

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
			block.CallDeferred("queeu_free");
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
