extends Node2D

const CharacterAction = preload("res://actions/character_action.gd")
var IdleAction = load("res://actions/idle_action.gd")
var GrabAction = load("res://actions/grab_action.gd")

var current_action: CharacterAction
var _window_movement_fractions: = Vector2(0, 0)


# [TODO] Reduce the OS.* call

func _ready():
    get_tree().get_root().set_transparent_background(true)
    OS.set_window_always_on_top(true)
    OS.set_window_mouse_passthrough($Hitbox.polygon)
    randomize()
    set_action(IdleAction)


func _process(delta):
    current_action._timer += delta
    current_action._process(delta)
    if Input.is_action_just_pressed("mouse_left"):
        set_action(GrabAction)


func set_action(action: GDScript, params: = []):
    if not current_action or current_action.can_move_to(action):
        if current_action:
            current_action._before_move()
        current_action = action.callv("new", [$".", $Sprite] + params)


func move_window_by(vec: Vector2):
    # Move window by vec, but deal with non-integer values
    # by saving and using non-integer part of the vector
    _window_movement_fractions += vec

    var screen = OS.get_screen_size()
    var window_position = OS.window_position
    var integer_part: = Vector2(int(_window_movement_fractions.x), int(_window_movement_fractions.y))
    _window_movement_fractions -= integer_part  # Only leave fractional part of vector
    window_position         += integer_part
    window_position.x = clamp(window_position.x, -32, screen.x - 96)
    OS.window_position = window_position


func disable_narrow_hitbox(on: bool):
    match on:
        false:
            OS.set_window_mouse_passthrough($Hitbox.polygon)
        true:
            OS.set_window_mouse_passthrough([])            


func play_sound(res: AudioStream):
    $Audio.stream = res
    $Audio.play()


func start_sound_loop(res: AudioStream):
    $AudioLoop.stream = res
    $AudioLoop.play()


func stop_sound_loop():
    $AudioLoop.stop()
