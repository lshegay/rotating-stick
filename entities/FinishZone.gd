extends SafeZone

func _ready():
  super._ready()

func on_body_entered(body: Node2D):
  if not body is Player:
    return

  super.on_body_entered(body)

  body.call_deferred('set_finished', position)

  var level_id = int(get_tree().current_scene.name.replace('Level', ''))
  LevelsState.levels_completed = max(LevelsState.levels_completed, level_id + 1)
  

func on_body_exited(body: Node2D):
  super.on_body_exited(body)