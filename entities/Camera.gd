extends Camera2D

@export var player: Player
var decay = 0.8  # How quickly the shaking stops [0, 1].
var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
  randomize()

func _process(delta):
  position.x = player.position.x
  position.y = player.position.y

  if trauma:
    trauma = clamp(trauma - decay * delta, 0, 0.2)
    shake()

func add_trauma(amount):
  trauma = min(trauma + amount, 1.0)

func shake():
  var amount = pow(trauma, trauma_power)
  rotation = max_roll * amount * randf_range(-1, 1)
  offset.x = max_offset.x * amount * randf_range(-1, 1)
  offset.y = max_offset.y * amount * randf_range(-1, 1)

func on_player_collided_wall():
  add_trauma(0.2)
