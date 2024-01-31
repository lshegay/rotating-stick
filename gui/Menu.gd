class_name Menu
extends Node2D

var current_item = 0
var current_item_node: RichTextLabel

func _ready():
  render_menu()

func _process(delta):
  if visible == false: return

  if Input.is_action_just_pressed("up"):
    current_item = max(current_item - 1, 0)
    render_menu()
  elif Input.is_action_just_pressed("down"):
    current_item = min(current_item + 1, $Buttons.get_children().size() - 1)
    render_menu()

  if Input.is_action_just_pressed("z"):
    pass

func render_menu():
  current_item_node = $Buttons.get_children()[current_item]

  var i = 0
  for node in $Buttons.get_children():
    if not node is RichTextLabel:
      continue

    if i == current_item:
      node.remove_theme_color_override('default_color')
    else:
      node.add_theme_color_override('default_color', Color(1, 1, 1, 0.7))

    i += 1