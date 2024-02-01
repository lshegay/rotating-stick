class_name Transition
extends Node2D

const frame_duration = 0.05

var transition = false
var end_transition = false
var circles_radius = 0
var transition_timer = 0

var callback: Callable

func _process(delta):
  if not transition and not end_transition: return

  transition_timer += delta

  if transition_timer >= frame_duration:
    queue_redraw()
    transition_timer = 0

    if transition and circles_radius >= 40:
      transition = false
      callback.call()

    if end_transition and circles_radius <= 0:
      end_transition = false
      callback.call()

func _draw():
  if not transition and not end_transition: return

  # 240x160
  for x in range(0, 11):
    for y in range(0, 8):
      draw_circle(Vector2(x * 24, y * 24), max(circles_radius - x, 0), Color(0.27, 0.26, 0.31, 1))

  if transition:
    circles_radius = circles_radius + 2
  elif end_transition:
    circles_radius = circles_radius - 2


func start_transition(action: Callable = func(): return):
  callback = action
  transition = true
  circles_radius = 0
  queue_redraw()


func start_end_transition(action: Callable = func(): return):
  callback = action
  end_transition = true
  circles_radius = 24
  queue_redraw()
