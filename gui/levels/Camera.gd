extends Camera2D

@export var cursor: Node2D

func _process(delta):
  position.y = cursor.position.y