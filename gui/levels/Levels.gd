extends Node2D

const row = 4.

var animate = false
var cursor_position = Vector2.ZERO
var controls = true
var tween: Tween

func _ready():
  cursor_position.x = LevelsState.levels_completed % int(row)
  cursor_position.y = int(LevelsState.levels_completed / row)

  render_levels()

  $Cursor.position.x = 50 + cursor_position.x * 48
  $Cursor.position.y = 32 + cursor_position.y * 48

  $HUD.get_node('Transition').start_end_transition()

func _process(delta):
  if not controls: return

  if Input.is_action_just_pressed('z'):
    var current_level = cursor_position.x + cursor_position.y * row
    if current_level > LevelsState.levels_completed:
      return

    controls = false
    $HUD.get_node('Transition').start_transition(func():
      get_tree().change_scene_to_file("res://scenes/levels/Level%s.tscn" % (current_level))
    )

  var input_x = Input.get_axis('left', 'right')
  var input_y = Input.get_axis('up', 'down')

  if not animate and (input_x != 0 or input_y != 0):
    if cursor_position.x == 0 and input_x == -1: return
    if cursor_position.x == row - 1 and input_x == 1: return
    if cursor_position.y == 0 and input_y == -1: return
    if cursor_position.y == int(LevelsState.levels / row) and input_y == 1: return

    $AudioClick.play()

    cursor_position.x += input_x
    cursor_position.y += input_y
    animate_cursor(Vector2(0, input_y) if input_x == 0 else Vector2(input_x, 0))


func animate_cursor(to: Vector2):
  animate = true
  if tween: tween.kill()

  tween = get_tree().create_tween()
  tween.set_parallel()

  $Cursor.skew = to.x * 0.3
  tween.tween_property($Cursor, 'skew', 0, 0.4).set_trans(Tween.TRANS_ELASTIC)
  await tween.tween_property($Cursor, 'position', Vector2($Cursor.position + to * 48), 0.2).set_trans(Tween.TRANS_SINE).finished
  animate = false

func render_levels():
  for i in range(0, LevelsState.levels):
    var x = (i * (int(row) - 1)) % 12
    var y = int(i / row) * (row - 1)
    var tilemap_pos = Vector2i(8, 10)

    if LevelsState.levels_completed == i:
      tilemap_pos = Vector2i(12, 10)
    elif LevelsState.levels_completed > i:
        tilemap_pos = Vector2i(10, 10)

    $Tilemap.set_cell(1, Vector2(x + 2, y + 2), 3, Vector2i(tilemap_pos.x, tilemap_pos.y))
    $Tilemap.set_cell(1, Vector2(x + 3, y + 2), 3, Vector2i(tilemap_pos.x + 1, tilemap_pos.y))
    $Tilemap.set_cell(1, Vector2(x + 2, y + 3), 3, Vector2i(tilemap_pos.x, tilemap_pos.y + 1))
    $Tilemap.set_cell(1, Vector2(x + 3, y + 3), 3, Vector2i(tilemap_pos.x + 1, tilemap_pos.y + 1))