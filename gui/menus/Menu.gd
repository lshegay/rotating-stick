class_name Menu
extends Node2D

var current_item = 0
var current_item_node: RichTextLabel
var start_pos = Vector2.ZERO
var controls = true

func _ready():
  start_pos = $ButtonSelected.position
  render_menu()

func _process(_delta):
  if not controls or not visible: return

  if Input.is_action_just_pressed("up"):
    current_item = max(current_item - 1, 0)
    render_menu()
    $ClickAudio.play()
  elif Input.is_action_just_pressed("down"):
    current_item = min(current_item + 1, $Buttons.get_children().size() - 1)
    render_menu()
    $ClickAudio.play()

  """ if Input.is_action_just_pressed("z"):
    $ClickAudio.play() """

func render_menu():
  current_item_node = $Buttons.get_children()[current_item]

  $ButtonSelected.position.y = start_pos.y + current_item * 16

func toggle():
  if visible: close()
  else: open()

func open():
  $ButtonSelected.position.y = start_pos.y
  visible = true

func close():
  visible = false