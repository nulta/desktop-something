class_name IdleAction
extends "res://actions/character_action.gd"

var WalkAction = load("res://actions/walk_action.gd")
var waitTime = 1


func _init(cn, cs).(cn,cs):
    _frameStart = 0
    _frameEnd   = 4
    waitTime = randf() * 8 + 1
    random_frame()

func _process(dt):
    process_animate_frame(1, dt)
    process_move_after(waitTime, WalkAction, dt)
