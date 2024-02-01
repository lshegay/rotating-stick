class_name HUD
extends CanvasLayer

var health = 3

func _ready():
  render_healthbar(health)
  $DiedMenu.visible = false
  $FinishedMenu.visible = false

  $Transition.start_end_transition()

func render_healthbar(value: int):
  health = value
  for i in range(0, 3):
    if i + 1 <= health:
      $Health.set_cell(0, Vector2(i, 0), 3, Vector2(4 + i, 10))
    else:
      $Health.set_cell(0, Vector2(i, 0), 3, Vector2(4 + i, 11))

func on_player_health_changed(value: int, previous: int):
  render_healthbar(value)

func on_player_died():
  $DiedMenu.visible = true

func on_player_finished():
  $FinishedMenu.visible = true
