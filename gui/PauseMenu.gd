extends Menu

@export var transition: Transition

func _process(delta):
  if not controls or not visible: return

  super._process(delta)

  if Input.is_action_just_pressed("z"):
    controls = false

    if current_item_node.text == 'Restart':
      transition.start_transition(func(): get_tree().reload_current_scene())
    elif current_item_node.text == 'Exit':
      transition.start_transition(func():
        get_tree().change_scene_to_file("res://scenes/Levels.tscn")
      )
