using Godot;
using System;

public class Player : Node2D
{
    [Signal]
    public delegate void HealthChanged(int health);

    [Signal]
    public delegate void Died();

    [Export]
    public int MaxHealth
    {
        get { return _health;  }
        set { _health = value; }
    }

    public enum States {
        Alive,
        Dead
    };

    private States _state = States.Alive;

    private int _health = 18;

    public void TakeDamage(int count)
    {
        if (_state == States.Dead) {
            return;
        }

        _health -= count;
        if (_health <= 0) {
            _health = 0;
            _state = States.Dead;
            EmitSignal("Died");
        }

        var animationPlayer = (AnimationPlayer) GetNode("AnimationPlayer");
        animationPlayer.Play("take_hit");

        EmitSignal("HealthChanged", _health);
    }

    public void OnAnimationPlayerAnimationFinished(string name)
    {
        if (_state != States.Dead || name != "take_hit") {
            return;
        }

        var animationPlayer = (AnimationPlayer) GetNode("AnimationPlayer");
        animationPlayer.Play("die");
    }
}