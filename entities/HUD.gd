class_name HUD
extends CanvasLayer

@export var player: Player

var health = 3

func _ready():
  render_healthbar(health)
  $PauseMenu.visible = false
  $FinishedMenu.visible = false
  $PainAvatar.visible = false

  $Transition.start_end_transition()

func _process(delta):
  if Input.is_action_just_pressed('x') and !player.is_died:
    $PauseMenu.toggle()
    player.no_controls = $PauseMenu.visible

func render_healthbar(value: int):
  health = value
  for i in range(0, 3):
    if i + 1 <= health:
      $Health.set_cell(0, Vector2(i, 0), 3, Vector2(4 + i, 10))
    else:
      $Health.set_cell(0, Vector2(i, 0), 3, Vector2(4 + i, 11))

func avatar_pain_animate():
  $Avatar.visible = false
  $PainAvatar.visible = true
  
  $AvatarTimer.stop()

  $AvatarTimer.start()
  await $AvatarTimer.timeout

  $Avatar.visible = true
  $PainAvatar.visible = false

func on_player_health_changed(value: int, previous: int):
  render_healthbar(value)

func on_player_died():
  $AvatarTimer.stop()
  $PauseMenu.visible = true
  $AudioLoose.play()

  $Avatar.visible = false
  $PainAvatar.visible = true

func on_player_finished():
  $FinishedMenu.visible = true
  $AudioWin.play()

  $Avatar.visible = false
  $WinAvatar.visible = true

func on_player_collided_wall():
  avatar_pain_animate()
