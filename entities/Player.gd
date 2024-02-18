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

var angular_velocity = 70
var angular_knockback_velocity = 800
var max_angular_velocity = 70

var health = 3

var invincibility_timeout = 0.2
var invincible = false
var springing = false
var in_safe_zone = false
var is_finished = false
var finished_move_to: Vector2

var is_died = false
var no_controls = false

func _physics_process(delta):
  if is_finished:
    rotation_degrees += rotation_direction * 800 * delta
    if finished_move_to:
      position = position.lerp(finished_move_to, 0.1)
    return

  if no_controls or is_died: return

  var input_direction = Input.get_vector("left", "right", "up", "down")

  angular_velocity += rotation_direction * rotation_speed * delta
  angular_velocity = clamp(
    angular_velocity,
    -max_angular_velocity,
    max_angular_velocity
  )

  var collision = move_and_collide(velocity * delta)
  if collision:
    if PhysicsServer2D.body_get_collision_layer(collision.get_collider_rid()) == 2:
      angular_velocity = -sign(angular_velocity) * angular_knockback_velocity

      var direction = collision.get_position() - position
      knockback = -direction.normalized() * knockback_velocity

      collided_wall.emit()
      get_damage()

      make_particles(collision.get_position())

  rotation_degrees += angular_velocity * delta

  if input_direction.length() > 0:
    velocity = input_direction * speed
  else:
    velocity = velocity.lerp(Vector2.ZERO, 0.5)

  velocity += knockback

  knockback = Vector2.ZERO

var animation_changed = false

func _process(_delta):
  if not animation_changed: return

  if in_safe_zone:
    invicible_animation()
  else:
    get_default_animation()

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

func invicible_animation():
  if not in_safe_zone: return
  animation_changed = false

  $TileMap.set_cell(0, Vector2(-2, 0), 3, Vector2i(0, 6))
  $TileMap.set_cell(0, Vector2(-1, 0), 3, Vector2i(1, 6))
  $TileMap.set_cell(0, Vector2(0, 0), 3, Vector2i(2, 6))
  $TileMap.set_cell(0, Vector2(1, 0), 3, Vector2i(1, 6))
  $TileMap.set_cell(0, Vector2(2, 0), 3, Vector2i(3, 6))

  await get_tree().create_timer(0.1).timeout
  if not in_safe_zone: return

  $TileMap.set_cell(0, Vector2(-2, 0), 3, Vector2i(0, 7))
  $TileMap.set_cell(0, Vector2(-1, 0), 3, Vector2i(1, 7))
  $TileMap.set_cell(0, Vector2(0, 0), 3, Vector2i(2, 7))
  $TileMap.set_cell(0, Vector2(1, 0), 3, Vector2i(1, 7))
  $TileMap.set_cell(0, Vector2(2, 0), 3, Vector2i(3, 7))

  await get_tree().create_timer(0.1).timeout

  invicible_animation()

func get_default_animation():
  animation_changed = false

  $TileMap.set_cell(0, Vector2(-2, 0), 3, Vector2i(0, 3))
  $TileMap.set_cell(0, Vector2(-1, 0), 3, Vector2i(1, 3))
  $TileMap.set_cell(0, Vector2(0, 0), 3, Vector2i(2, 3))
  $TileMap.set_cell(0, Vector2(1, 0), 3, Vector2i(1, 3))
  $TileMap.set_cell(0, Vector2(2, 0), 3, Vector2i(3, 3))

func die():
  $TileMap.visible = false
  $Collision.disabled = true
  in_safe_zone = true
  is_died = true
  no_controls = true
  died.emit()

  $DieParticles.emitting = true

func set_finished(move_to: Vector2):
  is_finished = true
  in_safe_zone = true
  no_controls = true
  $Collision.disabled = true
  finished_move_to = move_to
  finished.emit()

func springed():
  if springing: return
  rotation_direction = -rotation_direction
  angular_velocity = -angular_velocity
  springing = true

  await get_tree().create_timer(0.5).timeout
  springing = false

func make_particles(pos: Vector2):
  var particles: CPUParticles2D = $PainParticles.duplicate()

  particles.position = pos
  particles.visible = true
  particles.emitting = true
  get_parent().add_child(particles)

  await particles.finished
  get_parent().remove_child(particles)
  particles.queue_free()
