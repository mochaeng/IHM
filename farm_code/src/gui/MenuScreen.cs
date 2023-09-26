using Godot;
using System;

public partial class MenuScreen : Control
{
	public AudioStreamPlayer AudioMusic;
	public SettingsWindow SettingsWindow;

	public Button StartButton;
	public Button CreditButton;
	public Button SettingsButton;
	public Button TutorialButton;
	public Button HistoryButton;

	public MusicButton MusicButton;

	public Singleton Singleton;

	public override void _Ready()
	{
		Singleton = GetNode<Singleton>("/root/Singleton");

		SettingsWindow = GetNode<SettingsWindow>("SettingsWindow");
		MusicButton = GetNode<MusicButton>("SettingsWindow/Control/Panel/MusicButton");
		StartButton = GetNode<Button>("StartButton");
		CreditButton = GetNode<Button>("CreditButton");
		SettingsButton = GetNode<Button>("SettingsButton");
		TutorialButton = GetNode<Button>("TutorialButton");
		HistoryButton = GetNode<Button>("HistoryButton");
		AudioMusic = GetNode<AudioStreamPlayer>("AudioStreamPlayer");


		StartButton.Pressed += () => OnStartButtonPressed();
		CreditButton.Pressed += () => OnCreditButtonPressed();
		SettingsButton.Pressed += () => OnSettingsButtonPressed();
		TutorialButton.Pressed += () => OnTutorialButtonPressed();
		HistoryButton.Pressed += () => OnHistoryButtonPressed();
		SettingsWindow.ShouldCloseSettings += () => OnShouldCloseSettings();
		MusicButton.MusicToggle += (isActive) => ToggleMusic(isActive);

		SettingsWindow.Visible = false;
		AudioMusic.Playing = Singleton.IsSongsEnable;

		Singleton.SongsOptionChange += (isEnable) => ToggleMusic(isEnable);
	}

	public void OnSettingsWindowShouldCloseSettings()
	{
		SettingsWindow.Visible = false;
	}

	public void OnStartButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("WorldsSelection");
	}

	public void OnCreditButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("Credits");
	}

	public void OnSettingsButtonPressed()
	{
		SettingsWindow.Visible = true;
	}

	public void OnShouldCloseSettings()
	{
		SettingsWindow.Visible = false;
	}

	public void OnTutorialButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("Instructions");
	}

	public void OnHistoryButtonPressed()
	{
		Singleton.ChangeSceneWithTransition("History_1");
	}

	public void ToggleMusic(bool isEnable)
	{
		GD.Print(isEnable);
		AudioMusic.Playing = isEnable;
	}

}
