extends Node2D

var current_node_scene: Node
var current_hud: HUD
var current_level = LevelsState.current_level

func _ready() -> void:
  load_level(LevelsState.current_level)

func load_level(level: int):
  LevelsState.current_level = level

  if current_node_scene:
    $Level.remove_child(current_node_scene)

  if current_hud:
    remove_child(current_hud)

  var scene: PackedScene = load("res://scenes/levels/Level%s.tscn" % level)
  current_node_scene = scene.instantiate()

  var hud: PackedScene = load("res://gui/HUD.tscn")
  current_hud = hud.instantiate()

  $Level.add_child(current_node_scene)
  add_child(current_hud)

  var player: Player = current_node_scene.get_node("Player")
  player.connect("collided_wall", func():
    current_hud.on_player_collided_wall()
  )

  player.connect("died", func():
    current_hud.on_player_died()
  )

  player.connect("finished", func():
    current_hud.on_player_finished()
  )

  player.connect("health_changed", func(value: int, previous_value: int):
    current_hud.on_player_health_changed(value, previous_value)
  )

  current_hud.player = player
  current_hud.get_node("Transition").start_end_transition()

func load_next_level():
  LevelsState.current_level += 1

  load_level(LevelsState.current_level)

func reload_current_level():
  load_level(LevelsState.current_level)
