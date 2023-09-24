using Godot;
using Godot.Collections;
using System;
using System.Collections;
using System.Collections.Generic;

public partial class Dialogue : Control
{
    [Signal]
    public delegate void DialogueChangeEventHandler();

    [Signal]
    public delegate void ShouldChangeStageEventHandler();

    public List<Texture2D> NPCsTextures = new();
    public FileAccess DialogueFile;
    public int CurrentDialogueLine = 0;
    public Godot.Collections.Array Content;

    public void Initiate(string path, List<string> texturesPath)
    {
        LoadFile(path);
        LoadNPCTextures(texturesPath);
    }

    public void NextDialogue()
    {
        if (CurrentDialogueLine >= 0 && CurrentDialogueLine < Content.Count)
        {
            CurrentDialogueLine += 1;
            if (CurrentDialogueLine == Content.Count)
            {
                CurrentDialogueLine -= 1;
            }
            EmitSignal("DialogueChange");
        }
    }

    public void LoadFile(string path)
    {
        DialogueFile = FileAccess.Open(path, FileAccess.ModeFlags.Read);
        var fileContent = DialogueFile.GetAsText();
        var dictionaryContent = (Godot.Collections.Array)Json.ParseString(fileContent);
        Content = dictionaryContent;
    }

    public void LoadNPCTextures(List<string> textures)
    {
        foreach (var texture in textures)
        {
            var textureLoaded = (Texture2D)ResourceLoader.Load(texture);
            NPCsTextures.Add(textureLoaded);
        }
    }

    public void SetDialogue(Godot.Collections.Dictionary line)
    {
        var name = GetNode<RichTextLabel>("Name");
        var chat = GetNode<RichTextLabel>("Chat");
        var sprite = GetNode<Sprite2D>("Sprite2D");

        name.Text = (string)line["name"];
        chat.Text = (string)line["text"];
        sprite.Texture = NPCsTextures[(int)line["frame"]];
    }

    public Godot.Collections.Dictionary GetCurrentDialogueLine()
    {
        if (Content is null)
        {
            throw new Exception("You should initiate the dialogue before getting its content");
        }

        var currentContent = (Godot.Collections.Dictionary)Content[CurrentDialogueLine];
        if ((bool)currentContent["is_disruptive"])
        {
            EmitSignal("ShouldChangeStage");
        }
        return currentContent;
    }

    public void IncreaseCurrentDialogueLine()
    {
        CurrentDialogueLine += 1;
    }

}