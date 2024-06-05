extends Control

var board_size = 5
var upper_half_positions = []
var lower_half_positions = []

var original_upper_half_positions = []
var original_lower_half_positions = []

var green_cells_selected = 0
var max_green_cells = board_size + 1

var board_offset = Vector2(178,300)
var GRID_ONES = board_size + 1
var CELL_SIZE = 50
var lvl = 0
var cell_win = []

func _ready():
	randomize()
	generate_divisible_figure()
	
	create_board()
	create_refresh_button()
	create_check_button()
	create_reset_button()
	create_change_game()

func reset_original_positions():
	original_upper_half_positions = upper_half_positions.duplicate()
	original_lower_half_positions = lower_half_positions.duplicate()


func create_board():
	reset_original_positions()
	for x in range(board_size):
		for y in range(board_size):
			var button = Button.new()
			button.rect_min_size = Vector2(70, 70)#размер клеткм
			var current_position = Vector2(x, y)
			if upper_half_positions.find(current_position) != -1 or lower_half_positions.find(current_position) != -1:
				button.modulate = Color(0, 0, 3) # Зеленый цвет для клетки фигуры
			else:
				button.modulate = Color(3, 3, 3) # Белый цвет для остальных клеток
					
			button.connect("pressed", self, "_on_button_pressed", [current_position, button]) # Подключаем обработчик нажатия кнопки
			add_child(button)
			button.rect_position = current_position * 70 + board_offset
func refresh_board():
	generate_divisible_figure()
	update_board()
	green_cells_selected = 0

func _on_button_pressed(var button_position, button):
	if upper_half_positions.find(button_position) != -1 or lower_half_positions.find(button_position) != -1:
		if green_cells_selected < max_green_cells:
			button.modulate = Color(1, 0, 0)
			if upper_half_positions.find(button_position) != -1:
				upper_half_positions.erase(button_position)
			else:
				lower_half_positions.erase(button_position)

			green_cells_selected += 1

			if green_cells_selected == max_green_cells:
				check_result()
	else:
		print("Вы выбрали пустую клетку.")
	
	print("Верхняя половина:", upper_half_positions)
	print("Нижняя половина:", lower_half_positions)

func generate_divisible_figure():
	upper_half_positions.clear()
	lower_half_positions.clear()

	# Генерируем 4 симметричных пары клеток
	for i in range(2): 
		var random_position = Vector2(randi() % board_size, randi() % (board_size / 2))  # Используйте целочисленное деление
		upper_half_positions.append(random_position)
		lower_half_positions.append(Vector2(random_position.x, board_size - 1 - random_position.y)) 
	
	# Генерируем 1 случайную клетку
	var random_position = Vector2(randi() % board_size, randi() % board_size)
	while upper_half_positions.find(random_position) != -1 or lower_half_positions.find(random_position) != -1:
		random_position = Vector2(randi() % board_size, randi() % board_size)
	cell_win = random_position
	#  Определяем, в верхнюю или нижнюю половину добавить клетку
	if randi() % 2 == 0:
		upper_half_positions.append(random_position)
	else:
		lower_half_positions.append(random_position)

#////////////////       Кнопки в игре
func create_change_game():
	var custom_font = DynamicFont.new()
	custom_font.font_data = preload("res://Fonts/acumin-pro(VER).ttf")
	custom_font.size = 30

	var custom_style = StyleBoxFlat.new()
	custom_style.bg_color = Color(0, 0, 1)
	
	var btn_menu = Button.new()
	btn_menu.add_font_override("font", custom_font)
	btn_menu.text = "Menu"
	
	btn_menu.add_stylebox_override("normal", custom_style)
	btn_menu.add_stylebox_override("hover", custom_style)
	btn_menu.add_stylebox_override("pressed", custom_style)
	
	btn_menu.rect_min_size = Vector2(110, 75)
	btn_menu.set_position(Vector2(0, 0))
	btn_menu.add_color_override("font_color", Color(1, 1, 1))
	btn_menu.connect("pressed", self, "change_game")
	add_child(btn_menu)

func change_game():
	get_tree().change_scene("res://Scenes/StartGame.tscn")

func create_reset_button():
	var custom_font = DynamicFont.new()
	custom_font.font_data = preload("res://Fonts/acumin-pro(VER).ttf")
	custom_font.size = 30

	var custom_style = StyleBoxFlat.new()
	custom_style.bg_color = Color(0, 0, 1)
	
	var reset_button = Button.new()
	reset_button.add_font_override("font", custom_font)
	reset_button.text = "Reset"
	
	reset_button.add_stylebox_override("normal", custom_style)
	reset_button.add_stylebox_override("hover", custom_style)
	reset_button.add_stylebox_override("pressed", custom_style)
	
	reset_button.rect_min_size = Vector2(177, 60)
	reset_button.set_position(Vector2(532, 800))
	reset_button.add_color_override("font_color", Color(1, 1, 1))
	reset_button.connect("pressed", self, "reset_board")
	add_child(reset_button)
	
func create_refresh_button():
	var custom_font = DynamicFont.new()
	custom_font.font_data = preload("res://Fonts/acumin-pro(VER).ttf")
	custom_font.size = 30

	var custom_style = StyleBoxFlat.new()
	custom_style.bg_color = Color(0, 0, 1)
	var refresh_button = Button.new()
	refresh_button.add_font_override("font", custom_font)
	refresh_button.text = "Update"
	
	refresh_button.add_stylebox_override("normal", custom_style)
	refresh_button.add_stylebox_override("hover", custom_style)
	refresh_button.add_stylebox_override("pressed", custom_style)
	
	refresh_button.rect_min_size = Vector2(177, 60)#размер кнопки
	refresh_button.set_position(Vector2(11,800))
	refresh_button.add_color_override("font_color", Color(1, 1, 1))
	refresh_button.connect("pressed", self, "refresh_board")
	add_child(refresh_button)

func create_check_button():
	var custom_font1 = DynamicFont.new()
	custom_font1.font_data = preload("res://Fonts/acumin-pro(VER).ttf")
	custom_font1.size = 30

	var custom_style1 = StyleBoxFlat.new()
	custom_style1.bg_color = Color(0, 0, 1)
	var check_button = Button.new()
	check_button.add_font_override("font", custom_font1)
	check_button.text = "Check"
	check_button.add_stylebox_override("normal", custom_style1)
	check_button.add_stylebox_override("hover", custom_style1)
	check_button.add_stylebox_override("pressed", custom_style1)
	
	check_button.rect_min_size = Vector2(177, 60)#размер кнопки
	check_button.set_position(Vector2(281,800))
	check_button.add_color_override("font_color", Color(1, 1, 1))
	check_button.connect("pressed", self, "check_result")
	add_child(check_button)
	
	
func check_result():
	if green_cells_selected == 1 and upper_half_positions.find(cell_win) == -1 and lower_half_positions.find(cell_win) == -1:
		$Label.add_color_override("font_color",Color(5,0,10))
		$Label.text = "All good!"
		lvl = lvl + 1
	else:
		$Label.add_color_override("font_color",Color(0,10,5))
		$Label.text = "Try Again :D!Maybe you need another part!"

		
func update_board():
	for child in get_children():
		if child is Button and child.text != "Update" and child.text != "Check" and child.text != "Reset" and child.text != "Menu":
			remove_child(child)
	$Label.text = "lvl "+ str(lvl)

	create_board()
func reset_board():
	for child in get_children():
		if child is Button and child.text != "Update" and child.text != "Check" and child.text != "Reset" and child.text != "Menu":
			var position = (child.rect_position - board_offset) / 70
			if child.modulate == Color(1, 0, 0) and original_upper_half_positions.find(position) != -1:
				child.modulate = Color(0, 0, 3)
				upper_half_positions.append(position)
			if child.modulate == Color(1, 0, 0) and original_lower_half_positions.find(position) != -1:
				child.modulate = Color(0, 0, 3)
				lower_half_positions.append(position)  # Возвращаем копию исходного массива
	green_cells_selected = 0
	print("Карта обновлена")

