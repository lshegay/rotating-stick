extends Node2D

var controls = true

func _ready():
  $AudioTrack.play()

func _process(_delta):
  $Logo.position = $Logo.position.lerp(Vector2($Logo.position.x, 52), 0.05)

  if not controls: return
  if Input.is_action_just_pressed('z'):
    controls = false
    $Transition.start_transition(func():
      get_tree().change_scene_to_file("res://scenes/Selector.tscn")
    )
