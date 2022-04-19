class_name GettingUpAction
extends "res://actions/character_action.gd"

const ANIMATION_DELAY = 0.3
const MIN_VELOCITY = 1000
const BIG_VELOCITY = 2000

var IdleAction = load("res://actions/idle_action.gd")
var firstWait = 0


func _init(cn, cs, velocity: Vector2).(cn,cs):
    if velocity.length() < MIN_VELOCITY:
        return move_action(IdleAction)
    if velocity.length() >= BIG_VELOCITY:
        firstWait += (velocity.length() / 1000) - 0.5
        _characterNode.play_sound(load("res://assets/hit.mp3"))
    
    _frameStart = 15
    _frameEnd   = 18
    set_frame(0)
    _characterNode.disable_narrow_hitbox(true)

func _before_move():
    _characterNode.disable_narrow_hitbox(false)

func _process(dt):
    if _timer < firstWait:
        return
    process_animate_frame(ANIMATION_DELAY, dt)
    process_move_after(ANIMATION_DELAY * (_frameEnd - _frameStart + 1), IdleAction, dt)
