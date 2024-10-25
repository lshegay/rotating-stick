extends Node2D

var animate = false
var cursor_position = Vector2.ZERO
var controls = false
var tween: Tween

func _ready():
  cursor_position.x = LevelsState.levels_completed

  render_levels()

  $Cursor.position.x = (cursor_position.x + 1) * 48
  $Cursor.position.y = (cursor_position.y + 1) * 16

  $HUD/Transition.start_end_transition(func():
    controls = true
  )

  # $AudioTrack.play()

func _process(_delta):
  if not controls: return

  if Input.is_action_just_pressed('z'):
    var current_level = cursor_position.x
    if current_level > LevelsState.levels_completed:
      return

    controls = false

    $AudioTrack.stop()

    $HUD/Transition.start_transition(func():
      LevelsState.current_level = current_level

      get_tree().change_scene_to_file("res://scenes/MasterLevel.tscn")  # current_level
    )

  var input_x = Input.get_axis('left', 'right')

  if not animate and input_x != 0:
    if cursor_position.x == 0 and input_x == -1: return
    if cursor_position.x == LevelsState.levels_completed and input_x == 1: return

    $Cursor.get_node('Sprite').scale.x = -input_x

    $AudioClick.play()

    cursor_position.x += input_x
    animate_cursor(Vector2(input_x, 0))


func animate_cursor(to: Vector2):
  animate = true

  if tween:
    tween.kill()

  tween = get_tree().create_tween()
  tween.set_parallel()

  $Cursor.skew = to.x * 0.1
  tween.tween_property($Cursor, 'skew', 0, 0.4).set_trans(Tween.TRANS_ELASTIC)

  await tween.tween_property($Cursor, 'position', Vector2($Cursor.position + to * 48), 0.2).set_trans(Tween.TRANS_SINE).finished

  animate = false

func render_levels():
  for i in range(0, LevelsState.levels):
    var x = 6 + (i * 3)

    var tilemap_pos = Vector2i(8, 10)

    if LevelsState.levels_completed == i:
      tilemap_pos = Vector2i(12, 10)
    elif LevelsState.levels_completed > i:
      tilemap_pos = Vector2i(10, 10)

    $Tilemap.set_cell(1, Vector2(x + 2, 0), 3, Vector2i(tilemap_pos.x, tilemap_pos.y))
    $Tilemap.set_cell(1, Vector2(x + 3, 0), 3, Vector2i(tilemap_pos.x + 1, tilemap_pos.y))
    $Tilemap.set_cell(1, Vector2(x + 2, 1), 3, Vector2i(tilemap_pos.x, tilemap_pos.y + 1))
    $Tilemap.set_cell(1, Vector2(x + 3, 1), 3, Vector2i(tilemap_pos.x + 1, tilemap_pos.y + 1))
