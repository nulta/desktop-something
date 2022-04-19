class_name ThrownAction
extends "res://actions/character_action.gd"

const MIN_THROW_SPEED = 50
const MAX_THROW_SPEED = 2000
const MIN_FLOOR_BOUNCE_SPEED = 100
var GettingUpAction = load("res://actions/getting_up_action.gd")

var gravity = Vector2(0, 1200)
var desired_floor_y: float
var velocity: Vector2


func _init(cn, cs, initVelocity: = Vector2(0,0)).(cn,cs):
    print(initVelocity)
    _frameStart = 10
    _frameEnd   = 11
    desired_floor_y = OS.window_position.y
    velocity = initVelocity
    set_frame(0)
    _characterNode.disable_narrow_hitbox(true)

    if initVelocity.length() <= MIN_THROW_SPEED:
        velocity = Vector2.ZERO
    elif initVelocity.length() >= MAX_THROW_SPEED:
        velocity = velocity.normalized() * MAX_THROW_SPEED

    if initVelocity.length() >= MAX_THROW_SPEED * 0.66:
        gravity *= 2
        desired_floor_y += 200
        desired_floor_y = min(OS.get_screen_size().y - 128, desired_floor_y)


func _before_move():
    _characterNode.disable_narrow_hitbox(false)


func _process(dt):
    process_animate_frame(0.05, dt)
    process_physics(dt)


func process_physics(dt):
    # Add gravity to velocity
    velocity += gravity * dt

    # Add velocity to position
    _characterNode.move_window_by(velocity * dt)

    # Wall Hit Processing
    var window_position = OS.window_position
    var screenSize = OS.get_screen_size()

    if window_position.x == -32:
        # Touched the left wall
        velocity = velocity.bounce(Vector2.RIGHT)
        velocity.x *= 0.33
    elif window_position.x == screenSize.x - 96:
        # Touched the right wall
        velocity = velocity.bounce(Vector2.LEFT)
        velocity.x *= 0.33

    if window_position.y >= desired_floor_y:
        # Touched the floor
        _characterNode.move_window_by(Vector2(0, desired_floor_y - window_position.y))
        move_action(GettingUpAction, [velocity])
