class_name GrabAction
extends "res://actions/character_action.gd"

var IdleAction = load("res://actions/idle_action.gd")
var ThrownAction = load("res://actions/thrown_action.gd")
const WINDOW_PICKUP_OFFSET = Vector2(-64, -38)
const LONG_HOLD_TIME = 3

var animDelay = 0.3
var sinFrequency = 4
var longHold = false
var lastWindowPos: Vector2


func _init(cn, cs).(cn,cs):
    _frameStart = 10
    _frameEnd   = 11
    random_frame()
    _characterNode.disable_narrow_hitbox(true)
    _characterNode.play_sound(load("res://assets/grab.mp3"))
    lastWindowPos = OS.window_position


func _before_move():
    _characterNode.disable_narrow_hitbox(false)
    _characterSprite.position = Vector2(0, 0)
    _characterNode.stop_sound_loop()


func _process(dt):
    if not Input.is_mouse_button_pressed(BUTTON_LEFT):
        return ungrab((OS.window_position - lastWindowPos) / dt / 2)

    lastWindowPos = OS.window_position
    OS.window_position += _characterNode.get_global_mouse_position() + WINDOW_PICKUP_OFFSET

    ## Animation processing ##
    process_animate_frame(animDelay, dt)
    _characterSprite.position.y = sin(_timer * sinFrequency) * 2

    # When held more than LONG_HOLD_TIME seconds
    if _timer >= LONG_HOLD_TIME:
        if not longHold:
            # Oneshot events
            longHold = true
            _characterNode.stop_sound_loop()
            _characterNode.start_sound_loop(load("res://assets/grab_2.ogg"))
            animDelay = 0.07
            sinFrequency = 6
        # Move XPos using sawtooth graph
        _characterSprite.position.x = abs(fmod(_timer * 6, 2.0) - 1) * 2


func ungrab(velocity: Vector2):
    move_action(ThrownAction, [velocity])
