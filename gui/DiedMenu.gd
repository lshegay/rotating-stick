extends Menu

func _process(delta):
  if visible == false: return

  super._process(delta)

  if Input.is_action_just_pressed("z"):
    if current_item_node.text == 'Restart':
      get_tree().reload_current_scene()
    elif current_item_node.text == 'Exit':
      pass
