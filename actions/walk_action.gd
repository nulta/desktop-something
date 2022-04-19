class_name WalkAction
extends "res://actions/character_action.gd"

var IdleAction = load("res://actions/idle_action.gd")
const SPEED = 150
const ANIMATION_DELAY = 0.2
enum {LEFT = -1, RIGHT = 1}

var waitTime   = 1
var direction  = RIGHT
var frameCounter = 1


func _init(cn, cs).(cn,cs):
    _frameStart = 5
    _frameEnd   = 9
    waitTime = randf() * 3 + 2
    direction = LEFT if ((randi() % 2) == 1) else RIGHT
    set_frame(0)


func _process(dt):
    process_animate_frame(ANIMATION_DELAY, dt)
    process_move_after(waitTime, IdleAction, dt)
    process_moving(dt)


func _before_move():
    _characterSprite.flip_h = false


func process_moving(dt):
    _characterSprite.flip_h = (direction == LEFT)
    _characterNode.move_window_by(Vector2(direction * SPEED * dt, 0))
    
    var posX = OS.window_position.x
    if posX >= OS.get_screen_size().x - 96:
        direction = LEFT
    elif posX <= -32:
        direction = RIGHT


func next_frame():
    var frameLength = _frameEnd - _frameStart + 1
    var counterLength = (frameLength-1) * 2
    
    frameCounter += 1
    frameCounter %= counterLength
    if frameCounter >= frameLength:
        set_frame(counterLength - frameCounter)
    else:
        set_frame(frameCounter)
