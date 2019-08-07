using Godot;
using System;

public class Enemy : Node2D
{
    [Export]
    public int Strength = 6;

    public enum States {
        Idle,
        Attacking
    };

    private States _state = States.Idle;

    private Player _target;

    public override void _Ready()
    {
        _target = (Player) GetNode("../Player");
    }

    public void OnTimerTimeout()
    {
        if (_target == null) {
            var timer = (Timer) GetNode("Timer");
            timer.Stop();
            return;
        }

        if (_state != States.Idle) {
            return;
        }

        _state = States.Attacking;

        var animationPlayer = (AnimationPlayer) GetNode("AnimationPlayer");
        animationPlayer.Play("anticipate");
    }

    public void DamageTarget(Player target, int damage)
    {
        target.TakeDamage(damage);
    }

    public void OnAnimationPlayerAnimationFinished(string name)
    {
        if (name == "attack") {
            _state = States.Idle;
        }

        if (name == "anticipate") {
            var animationPlayer = (AnimationPlayer) GetNode("AnimationPlayer");
            animationPlayer.Play("attack");
            DamageTarget(_target, Strength);
        }
    }

    public void OnPlayerDied()
    {
        _target = null;
    }

}