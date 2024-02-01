extends Menu

@export var transition: Transition

var current_level: StringName

func _ready():
  super._ready()

  current_level = get_tree().current_scene.name

func _process(delta):
  if visible == false: return

  super._process(delta)

  if Input.is_action_just_pressed("z"):
    if current_item_node.text == 'Next Level':
      transition.start_transition(func():
        get_tree().change_scene_to_file("res://scenes/levels/Level%s.tscn" % (int(current_level.replace('Level', '')) + 1))
      )
    elif current_item_node.text == 'Restart':
      transition.start_transition(func(): get_tree().reload_current_scene())
    elif current_item_node.text == 'Exit':
      transition.start_transition(func():
        get_tree().change_scene_to_file("res://scenes/Levels.tscn")
      )

