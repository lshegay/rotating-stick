extends Menu

var current_level: StringName

func _ready():
  super._ready()

  current_level = get_tree().current_scene.name

func _process(delta):
  if visible == false: return

  super._process(delta)

  if Input.is_action_just_pressed("z"):
    if current_item_node.text == 'Next Level':
      get_tree().change_scene_to_file("res://scenes/levels/Level%s.tscn" % (int(current_level.replace('Level', '')) + 1))
    elif current_item_node.text == 'Restart':
      get_tree().reload_current_scene()
    elif current_item_node.text == 'Exit':
      pass
