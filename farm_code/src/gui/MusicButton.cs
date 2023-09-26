using Godot;
using System;

public partial class MusicButton : Button
{
	[Signal]
	public delegate void MusicToggleEventHandler(bool isActive);

	public Theme OffTheme;
	public Theme OnTheme;

	public bool IsActive = false;
	public Singleton Singleton;

	public override void _Ready()
	{
		Singleton = GetNode<Singleton>("/root/Singleton");

		OffTheme = ResourceLoader.Load<Theme>("res://scenes/gui/themes/off_button.tres");
		OnTheme = ResourceLoader.Load<Theme>("res://scenes/gui/themes/on_button.tres");
		IsActive = Singleton.IsSongsEnable;

		ChangeTexture();
	}

	public void ChangeTexture()
	{
		if (IsActive)
		{
			this.Theme = OnTheme;
		}
		else
		{
			this.Theme = OffTheme;
		}
	}

	public override void _Pressed()
	{
		IsActive = !IsActive;
		Singleton.SetIsSongsEnable(IsActive);
		ChangeTexture();
		EmitSignal("MusicToggle", IsActive);
	}

}
