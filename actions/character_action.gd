extends Reference


var _characterNode: Node2D
var _characterSprite: Sprite

var _frameStart        = 0
var _frameEnd          = 0
var _frameCountCurrent = 0

var _animTimer = 0
var _moveTimer = 0
var _timer     = 0


func _init(characterNode: Node2D, characterSprite: Sprite):
    _characterNode   = characterNode
    _characterSprite = characterSprite


func _process(_dt: float):
    pass  # Override me!

func _before_move():
    pass  # Override me!

func can_move_to(_name: GDScript) -> bool:
    return true  # Override me!


# Set frame (Starting from 0)
func set_frame(index: int):
    _frameCountCurrent = index
    _characterSprite.frame = _frameStart + index


func next_frame():
    set_frame((_frameCountCurrent + 1) % (_frameEnd - _frameStart + 1))


func random_frame():
    set_frame(randi() % (_frameEnd - _frameStart + 1))

func process_animate_frame(delay, delta: float):
    _animTimer += delta
    if _animTimer >= delay:
        _animTimer = 0
        next_frame()

func process_move_after(delay, to: GDScript, delta: float):
    _moveTimer += delta
    if _moveTimer >= delay:
        move_action(to)

func move_action(to: GDScript, params: = []):
    _characterNode.set_action(to, params)
