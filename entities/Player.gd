class_name Player
extends CharacterBody2D

signal health_changed(value: int, previous_value: int)
signal collided_wall
signal died
signal finished

var speed = 120
var rotation_speed = 400
var rotation_direction = 1
var knockback_velocity = 200
var knockback = Vector2.ZERO

var angular_velocity = 100
var angular_knockback_velocity = 800
var max_angular_velocity = 100

var health = 3

var invincibility_timeout = 0.2
var invincible = false
var in_safe_zone = false
var is_finished = false
var finished_move_to: Vector2

var is_died = false

func get_damage():
  $HurtAudio.play()

  if invincible or in_safe_zone: return

  invincible = true
  health -= 1
  health_changed.emit(health, health + 1)

  if health == 0:
    die()

  modulate.a = 0.5

  await get_tree().create_timer(invincibility_timeout).timeout

  modulate.a = 1
  invincible = false

func die():
  $TileMap.visible = false
  $Collision.disabled = true
  in_safe_zone = true
  is_died = true
  died.emit()

func set_finished(move_to: Vector2):
  is_finished = true
  in_safe_zone = true
  $Collision.disabled = true
  finished_move_to = move_to
  finished.emit()

func _physics_process(delta):
  if is_died: return

  if is_finished:
    rotation_degrees += 800 * delta
    if finished_move_to:
      position = position.lerp(finished_move_to, 0.1)
    return

  var input_direction = Input.get_vector("left", "right", "up", "down")

  angular_velocity += rotation_direction * rotation_speed * delta
  angular_velocity = clamp(
    angular_velocity,
    -max_angular_velocity,
    max_angular_velocity
  )

  var collision = move_and_collide(velocity * delta)
  if collision:
    angular_velocity = -sign(angular_velocity) * angular_knockback_velocity

    var direction = collision.get_position() - position
    knockback = -direction.normalized() * knockback_velocity

    collided_wall.emit()
    get_damage()

  rotation_degrees += angular_velocity * delta

  if input_direction.length() > 0:
    velocity = input_direction * speed
  else:
    velocity = velocity.lerp(Vector2.ZERO, 0.1)

  velocity += knockback

  knockback = Vector2.ZERO
