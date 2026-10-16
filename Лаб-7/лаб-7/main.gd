
extends Node2D

# Параметры физической модели
var mass = 2.0
var gravity_values = [500.0, 750.0, 1000.0]
var experiment = 0

var ball_position = Vector2(400, 80)
var velocity = 0.0
var acceleration = 500.0

var floor_y = 440.0
var ball_radius = 18.0
var bounce = 0.6

var time_passed = 0.0
var physics_step = 1.0 / 60.0
var accumulator = 0.0


func _ready():
	reset_ball()


# Возвращаем шар в начальное положение
func reset_ball():
	ball_position = Vector2(400, 80)
	velocity = 0.0
	acceleration = gravity_values[experiment]
	time_passed = 0.0
	accumulator = 0.0
	queue_redraw()


# Обработка нажатий клавиш
func _input(event):
	if event is InputEventKey:
		if event.pressed and not event.echo:
			match event.keycode:
				KEY_1:
					experiment = 0
					reset_ball()

				KEY_2:
					experiment = 1
					reset_ball()

				KEY_3:
					experiment = 2
					reset_ball()

				KEY_R:
					reset_ball()

				KEY_T:
					if physics_step < 0.05:
						physics_step = 1.0 / 15.0
					else:
						physics_step = 1.0 / 60.0
					reset_ball()


# Игровой цикл
func _process(delta):
	accumulator += min(delta, 0.1)

	while accumulator >= physics_step:
		simulate_physics(physics_step)
		accumulator -= physics_step

	queue_redraw()


# Расчёт физики
func simulate_physics(dt):
	var force = mass * acceleration
	var current_acceleration = force / mass

	velocity += current_acceleration * dt
	ball_position.y += velocity * dt

	# Отскок от пола с потерей энергии
	if ball_position.y + ball_radius >= floor_y:
		ball_position.y = floor_y - ball_radius
		velocity = -abs(velocity) * bounce

	time_passed += dt


# Рисование игры
func _draw():
	var font = ThemeDB.fallback_font

	# Фон
	draw_rect(
		Rect2(0, 0, 800, 500),
		Color("#19243A")
	)

	# Пол
	draw_line(
		Vector2(0, floor_y),
		Vector2(800, floor_y),
		Color.GREEN,
		5
	)

	# Шар
	draw_circle(
		ball_position,
		ball_radius,
		Color.YELLOW
	)

	# Информация
	var info = [
		"LAB 07 - PHYSICS",
		"Experiment: " + str(experiment + 1),
		"Mass: " + str(mass),
		"Gravity: " + str(acceleration),
		"Velocity: " + str(snapped(velocity, 0.1)),
		"Position Y: " + str(snapped(ball_position.y, 0.1)),
		"Time: " + str(snapped(time_passed, 0.01)),
		"Step: " + str(snapped(physics_step, 0.0001)),
		"1 / 2 / 3 - Experiments",
        "R - Restart | T - Change Step"
	]

	for i in range(info.size()):
		draw_string(
			font,
			Vector2(20, 30 + i * 27),
			info[i],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			18,
			Color.WHITE
		)
