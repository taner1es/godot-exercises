using Godot;
using System;

public class Gui : MarginContainer
{
    private Label _numberLabel;
    private TextureProgress _bar;
    private Tween _tween;

    public override void _Ready()
    {
        _bar = (TextureProgress) GetNode("Bars/LifeBar/TextureProgress");
        _tween = (Tween) GetNode("Tween");
        _numberLabel = (Label) GetNode("Bars/LifeBar/Count/Background/Number");
    }
}