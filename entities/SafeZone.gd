class_name SafeZone
extends Area2D

func _ready():
  connect('body_entered', on_body_entered)
  connect('body_exited', on_body_exited)

func on_body_entered(body: Node2D):
  if not body is Player:
    return

  body.in_safe_zone = true

func on_body_exited(body: Node2D):
  if not body is Player:
    return

  body.in_safe_zone = false