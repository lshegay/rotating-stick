extends Menu

@export var transition: Transition
@onready var master_level = $"/root/MasterLevel"

func _ready():
  super._ready()

func _process(delta):
  if not controls or not visible: return

  super._process(delta)

  if Input.is_action_just_pressed("z"):
    controls = false

    if current_item_node.text == 'Next Level':
      transition.start_transition(func():
        $"/root/MasterLevel".load_next_level()
      )
    elif current_item_node.text == 'Restart':
      transition.start_transition(func(): master_level.reload_current_level())
    elif current_item_node.text == 'Exit':
      transition.start_transition(func():
        get_tree().change_scene_to_file("res://scenes/Selector.tscn")
      )

