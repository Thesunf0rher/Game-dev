
extends Node2D

var player = Vector2(100, 100)
var coin = Vector2(300, 200)
var enemy = Vector2(450, 250)

var speed = 250.0
var score = 0
var time_left = 30.0
var game_over = false

func _ready():
	randomize()
	new_coin()

func new_coin():
	coin = Vector2(
		randf_range(40, 760),
		randf_range(60, 460)
	)

func _process(delta):
	if game_over:
		if Input.is_key_pressed(KEY_R):
			get_tree().reload_current_scene()
		return

	time_left -= delta

	if time_left <= 0:
		time_left = 0
		game_over = true

	var direction = Vector2.ZERO

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1

	player += direction.normalized() * speed * delta

	player.x = clamp(player.x, 20, 780)
	player.y = clamp(player.y, 20, 480)

	if player.distance_to(coin) < 30:
		score += 1
		new_coin()

	if player.distance_to(enemy) < 40:
		game_over = true

	queue_redraw()

func _draw():
	draw_rect(Rect2(0, 0, 800, 500), Color("#19243A"))

	draw_rect(Rect2(player - Vector2(18, 18), Vector2(36, 36)), Color.CYAN)

	draw_circle(coin, 13, Color.YELLOW)

	draw_rect(Rect2(enemy - Vector2(25, 25), Vector2(50, 50)), Color.RED)

	var font = ThemeDB.fallback_font

	draw_string(font, Vector2(20, 30), "Score: " + str(score),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)

	draw_string(font, Vector2(600, 30), "Time: " + str(ceil(time_left)),
		HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)

	if game_over:
		draw_rect(Rect2(180, 160, 440, 170), Color("#30384B"))
		draw_string(font, Vector2(290, 215), "GAME OVER",
			HORIZONTAL_ALIGNMENT_LEFT, -1, 35, Color.WHITE)
		draw_string(font, Vector2(290, 255), "Score: " + str(score),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.YELLOW)
		draw_string(font, Vector2(265, 300), "Press R to restart",
			HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color.WHITE)
