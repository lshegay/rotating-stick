extends Area2D

func _ready():
  connect('body_entered', on_body_entered)
  connect('body_exited', on_body_exited)

  $Sprite.connect('animation_finished', on_animation_finished)

func on_body_entered(body: Node2D):
  if not body is Player: return 

  $Sprite.animation = 'springed';
  $Sprite.play()
  $AudioSpring.play()
  body.springed()

func on_body_exited(body: Node2D):
  if not body is Player: return 

func on_animation_finished():
  $Sprite.animation = 'default';
  $Sprite.stop()
