using Godot;
using System;
using System.Collections.Generic;

public partial class Player : CharacterBody2D
{
	[Signal]
	public delegate void SadEmotedEventHandler();

	[Export]
	public float Speed = 300.0f;

	[Export]
	public float WalkSpeed = 2.0f;

	public AnimationTree AnimationTree;
	public RayCast2D RayCast;
	public AnimatedSprite2D AnimatedSprite;
	public AnimatedSprite2D SadEmote;

	public const int TILE_SIZE = 16;

	public enum PlayerState { IDLE, TURNING, WALKING, WATERING, AXING }
	public enum FacingDirection { LEFT, RIGHT, UP, DOWN }

	public PlayerState CurrentPlayerState = PlayerState.IDLE;
	public FacingDirection PlayerFacingDirection = FacingDirection.DOWN;

	public Vector2 InputDirection = Vector2.Zero;
	public Vector2 InitialPosition = Vector2.Zero;
	public double PercentMoveToNextTile = 0.0f;

	public string LastActionExecuted = "";

	public Dictionary<string, Vector2> Directions;

	public Vector2 PrevInputDirection;

	public override void _Ready()
	{
		AnimationTree = GetNode<AnimationTree>("AnimationTree");
		RayCast = GetNode<RayCast2D>("MoveRayCast2D");
		AnimatedSprite = GetNode<AnimatedSprite2D>("AnimatedSprite2D");
		SadEmote = GetNode<AnimatedSprite2D>("SadEmote");

		Directions = new() {
			{"left", new Vector2(-1, 0)},
			{"right", new Vector2(1, 0)},
			{"up", new Vector2(0, -1)},
			{"down", new Vector2(0, 1)},
			{"minus_90", new Vector2(0, 0)},
			{"plus_90", new Vector2(0, 0)},
			{"empty", new Vector2(0,0)},
		};

		AnimationTree.Active = true;
		PrevInputDirection = GetCurrentVectorPosition();
		Connect("SadEmoted", Callable.From(RunSadEmote));
	}

	public void UpdateSelect()
	{
		if (InputDirection.X < 0)
		{
			AnimatedSprite.Position = new Vector2(0, 16);
		}
		else if (InputDirection.X > 0)
		{
			AnimatedSprite.Position = new Vector2(32, 16);
		}
		else if (InputDirection.Y < 0)
		{
			AnimatedSprite.Position = new Vector2(16, 0);
		}
		else if (InputDirection.Y > 0)
		{
			AnimatedSprite.Position = new Vector2(16, 32);
		}
	}

	public override void _Process(double delta)
	{
		UpdateParameters();
		UpdateSelect();

		GD.Print(InputDirection);
	}

	public void UpdateRayCastToPlayerDirection()
	{
		var desiredStep = InputDirection * TILE_SIZE / 1.94f;
		RayCast.TargetPosition = desiredStep;
		RayCast.ForceUpdateTransform();
	}

	public override void _PhysicsProcess(double delta)
	{
		switch (CurrentPlayerState)
		{
			case PlayerState.TURNING:
				break;
			case PlayerState.WALKING:
				Move(delta);
				break;
			case PlayerState.IDLE:
				InputDirection = Vector2.Zero;
				ProcessPlayerInput();
				break;
			case PlayerState.WATERING:
				break;
			case PlayerState.AXING:
				break;
		}

		UpdateRayCastToPlayerDirection();
	}

	public void ProcessPlayerInput()
	{
		if (InputDirection.Y == 0)
		{
			InputDirection.X = (int)Input.GetActionStrength("right") - (int)Input.GetActionStrength("left");
		}
		if (InputDirection.X == 0)
		{
			InputDirection.Y = (int)Input.GetActionStrength("down") - (int)Input.GetActionStrength("up");
		}

		if (Input.IsActionJustPressed("watering"))
		{
			CurrentPlayerState = PlayerState.WATERING;
		}

		if (Input.IsActionJustPressed("axing"))
		{
			CurrentPlayerState = PlayerState.AXING;
		}

		TravelLogicUpdate();
	}

	public Boolean IsNeedToTurn()
	{
		var newFacingDirection = FacingDirection.LEFT;

		if (InputDirection.X < 0)
		{
			newFacingDirection = FacingDirection.LEFT;
		}
		else if (InputDirection.X > 0)
		{
			newFacingDirection = FacingDirection.RIGHT;
		}
		else if (InputDirection.Y < 0)
		{
			newFacingDirection = FacingDirection.UP;
		}
		else if (InputDirection.X > 0)
		{
			newFacingDirection = FacingDirection.DOWN;
		}

		if (PlayerFacingDirection != newFacingDirection)
		{
			PlayerFacingDirection = newFacingDirection;
			return true;
		}

		PlayerFacingDirection = newFacingDirection;
		return false;
	}

	public async void RunSadEmote()
	{
		SadEmote.Visible = true;
		await ToSignal(GetTree().CreateTimer(0.5), "timeout");
		SadEmote.Visible = false;
		EmitSignal("SadEmoted");
	}

	public void TurnPlayer()
	{
		CurrentPlayerState = PlayerState.TURNING;
		UpdateRayCastToPlayerDirection();
	}

	public void DoWatering()
	{
		CurrentPlayerState = PlayerState.WATERING;
		LastActionExecuted = "watering";
	}

	public void DoAxing()
	{
		CurrentPlayerState = PlayerState.AXING;
		LastActionExecuted = "axing";
	}

	public void finished_turning()
	{
		CurrentPlayerState = PlayerState.IDLE;
		UpdateRayCastToPlayerDirection();
	}

	public void finished_watering()
	{
		CurrentPlayerState = PlayerState.IDLE;
	}

	public void finished_axing()
	{
		CurrentPlayerState = PlayerState.IDLE;
	}

	public Vector2 GetMinus90DirectionalVector()
	{
		var dir = Vector2.Zero;

		if (PrevInputDirection.X < 0)
		{
			dir = Directions["down"];
		}
		else if (PrevInputDirection.X > 0)
		{
			dir = Directions["up"];
		}
		else if (PrevInputDirection.Y < 0)
		{
			dir = Directions["left"];
		}
		else if (PrevInputDirection.Y > 0)
		{
			dir = Directions["right"];
		}

		return dir;
	}

	public Vector2 GetPlus90DirectionalVector()
	{
		var dir = Vector2.Zero;

		if (PrevInputDirection.X < 0)
		{
			dir = Directions["up"];
		}
		else if (PrevInputDirection.X > 0)
		{
			dir = Directions["down"];
		}
		else if (PrevInputDirection.Y < 0)
		{
			dir = Directions["right"];
		}
		else if (PrevInputDirection.Y > 0)
		{
			dir = Directions["left"];
		}

		return dir;
	}

	public Vector2 GetCurrentVectorPosition()
	{
		var dir = Vector2.Zero;

		dir = PlayerFacingDirection switch
		{
			FacingDirection.LEFT => Directions["left"],
			FacingDirection.RIGHT => Directions["right"],
			FacingDirection.DOWN => Directions["down"],
			FacingDirection.UP => Directions["up"],
			_ => Vector2.Zero,
		};

		return dir; ;
	}

	public void UpdateAnimationTree()
	{
		AnimationTree.Set("parameters/Idle/blend_position", InputDirection);
		AnimationTree.Set("parameters/Walk/blend_position", InputDirection);
		AnimationTree.Set("parameters/Turning/blend_position", InputDirection);
		AnimationTree.Set("parameters/Watering/blend_position", InputDirection); 
		AnimationTree.Set("parameters/Axing/blend_position", InputDirection);
	}

	public void UpdateParameters()
	{
		if (InputDirection != Vector2.Zero)
		{
			UpdateAnimationTree();
		}

		switch (CurrentPlayerState)
		{
			case PlayerState.WALKING:
				AnimationTree.Set("parameters/conditions/Walking", true);
				AnimationTree.Set("parameters/conditions/Idle", false);
				AnimationTree.Set("parameters/conditions/Turning", false);
				AnimationTree.Set("parameters/conditions/Watering", false);
				AnimationTree.Set("parameters/conditions/Axing", false);
				break;
			case PlayerState.IDLE:
				AnimationTree.Set("parameters/conditions/Idle", true);
				AnimationTree.Set("parameters/conditions/Walking", false);
				AnimationTree.Set("parameters/conditions/Turning", false);
				AnimationTree.Set("parameters/conditions/Watering", false);
				AnimationTree.Set("parameters/conditions/Axing", false);
				break;
			case PlayerState.TURNING:
				AnimationTree.Set("parameters/conditions/Turning", true);
				AnimationTree.Set("parameters/conditions/Idle", false);
				AnimationTree.Set("parameters/conditions/Walking", false);
				AnimationTree.Set("parameters/conditions/Watering", false);
				AnimationTree.Set("parameters/conditions/Axing", false);
				break;
			case PlayerState.WATERING:
				AnimationTree.Set("parameters/conditions/Watering", true);
				AnimationTree.Set("parameters/conditions/Idle", false);
				AnimationTree.Set("parameters/conditions/Walking", false);
				AnimationTree.Set("parameters/conditions/Turning", false);
				AnimationTree.Set("parameters/conditions/Axing", false);
				break;
			case PlayerState.AXING:
				AnimationTree.Set("parameters/conditions/Axing", true);
				AnimationTree.Set("parameters/conditions/Watering", false);
				AnimationTree.Set("parameters/conditions/Idle", false);
				AnimationTree.Set("parameters/conditions/Walking", false);
				AnimationTree.Set("parameters/conditions/Turning", false);
				break;
		}
	}

	public void MoveByDirection(String direction)
	{
		Vector2 vecDir = direction switch
		{
			"minus_90" => GetMinus90DirectionalVector(),
			"plus_90" => GetPlus90DirectionalVector(),
			"water" or "axing" => PrevInputDirection,
			_ => Directions[direction],
		};

		if (InputDirection.Y == 0)
		{
			InputDirection.X += vecDir.X;
		}
		if (InputDirection.X == 0)
		{
			InputDirection.Y += vecDir.Y;
		}

		PrevInputDirection = InputDirection;

		GD.Print("Posição -> " + direction);
		GD.Print(InputDirection);

		if (InputDirection != Vector2.Zero)
		{
			switch (direction)
			{
				case "minus_90":
				case "plus_90":
					TurnPlayer();
					break;
				case "water":
					DoWatering();
					break;
				case "axing":
					DoAxing();
					break;
				default:
					InitialPosition = Position;
					CurrentPlayerState = PlayerState.WALKING;
					break;
			}
		}
	}

	public void TravelLogicUpdate()
	{
		if (InputDirection != Vector2.Zero)
		{
			AnimationTree.Set("parameters/Idle/blend_position", InputDirection);
			AnimationTree.Set("parameters/Walk/blend_position", InputDirection);
			AnimationTree.Set("parameters/Turning/blend_position", InputDirection);
			AnimationTree.Set("parameters/Watering/blend_position", InputDirection);
			AnimationTree.Set("parameters/Axing/blend_position", InputDirection);

			if (IsNeedToTurn())
			{
				CurrentPlayerState = PlayerState.TURNING;
			}
			else
			{
				InitialPosition = Position;
				CurrentPlayerState = PlayerState.WALKING;
			}
		}
	}

	public void Move(double delta)
	{
		UpdateRayCastToPlayerDirection();

		if (!RayCast.IsColliding())
		{
			PercentMoveToNextTile += WalkSpeed * delta;
			if (PercentMoveToNextTile >= 1.0)
			{
				Position = InitialPosition + (TILE_SIZE * InputDirection);
				PercentMoveToNextTile = 0.0f;
				CurrentPlayerState = PlayerState.IDLE;
			}
			else
			{
				Position = InitialPosition + (TILE_SIZE * InputDirection * (float)PercentMoveToNextTile);
			}
		}
		else
		{
			CurrentPlayerState = PlayerState.IDLE;
			PercentMoveToNextTile = 0.0f;
		}
	}

	public void InteractWithEntity()
	{
		if (RayCast.IsColliding())
		{
			GD.Print(RayCast.GetCollider());
			var entity = RayCast.GetCollider();
			if (LastActionExecuted == "watering")
			{
				entity.EmitSignal("Interacted");
			}
			else
			{
				entity.EmitSignal("Interacted");
			}
		}
	}
}