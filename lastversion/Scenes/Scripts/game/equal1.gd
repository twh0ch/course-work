extends Control

var board_size = 6

var upper = []
var lower = []
var left = []
var right = []
var copy_upper = []
var copy_lower = []
var copy_left = []
var copy_right = []

var board_offset = Vector2(178, 300)

var lvl = 0
var half_size = randi() % 4 + 3
var green_cells_selected = 0

func _ready():
	randomize()
	generate_divisible_figure()
	
	copy_upper = upper.duplicate()
	copy_lower = lower.duplicate()
	copy_left = left.duplicate()
	copy_right = right.duplicate()

	create_board()
	create_refresh_button()
	create_check_button()
	create_reset_button()
	create_change_game()

func create_board():
	for x in range(board_size):
		for y in range(board_size):
			var button = Button.new()
			button.rect_min_size = Vector2(70, 70) # размер клетки
			var current_position = Vector2(x, y)
			if upper.find(current_position) != -1 or lower.find(current_position) != -1:
				if lvl < 3:
					button.modulate = Color(0, 5, 0) 
				elif lvl  < 6:
					button.modulate = Color(0, 0, 1) 
				elif lvl  < 9:
					button.modulate = Color(0, 1, 2) 
				elif lvl < 12:
					button.modulate = Color(0, 10, 3) 
			else:
				button.modulate = Color(3, 3, 3) # Белый цвет для остальных клеток
					
			button.connect("pressed", self, "_on_button_pressed", [current_position, button]) # Подключаем обработчик нажатия кнопки
			add_child(button)
			button.rect_position = current_position * 70 + board_offset

func refresh_board():
	generate_divisible_figure()
	update_board()
	green_cells_selected = 0

func _on_button_pressed(button_position, button):
	print(half_size)
	if upper.find(button_position) != -1 or lower.find(button_position) != -1:
		if green_cells_selected < half_size:
			button.modulate = Color(1, 0, 0)
			if upper.find(button_position) != -1:
				upper.erase(button_position)
			elif lower.find(button_position) != -1:
				lower.erase(button_position)

			green_cells_selected += 1

			if green_cells_selected == half_size:
				check_result()
	else:
		print("Вы выбрали пустую клетку.")
	
	print("Верхняя половина(основная часть фигуры):", upper)
	print("Нижняя половина(основная часть фигуры):", lower)
	#print("Левая половина(доп возможная фигура):", left)
	#print("Правая половина(доп возможная фигура):", right)
	
func try_shift(shift: Vector2) -> bool:
		for pos in upper:
			var shifted_pos = pos + shift
			if upper.find(shifted_pos) != -1 or shifted_pos.x < 0 or shifted_pos.x >= board_size or shifted_pos.y < 0 or shifted_pos.y >= board_size:
				return false

		# Если все позиции валидны, заполняем lower
		lower.clear()
		for pos in upper:
			var shifted_pos = pos + shift
			lower.append(shifted_pos)
		return true
			
func generate_divisible_figure():
	upper.clear()
	lower.clear()
#		if lvl == 2 or lvl == 5 or lvl == 8 or lvl == 11 or lvl == 14:
	half_size = randi() % 3 + 4  # Генерация длины фигуры от 3 до 5
	$Label.add_color_override("font_color", Color(0,10,5))
	$Label.text = "mandatory level"
	if lvl == 2:
		half_size =  3

		while upper.size() < half_size:
			
			upper.append(Vector2(2,5))
			upper.append(Vector2(1,3))
			upper.append(Vector2(3,3))
			
			lower.append(Vector2(2,3))
			lower.append(Vector2(1,1))
			lower.append(Vector2(3,1))
	elif lvl == 5:
		half_size =  5

		while upper.size() < half_size:
			
			upper.append(Vector2(0,0))
			upper.append(Vector2(0,2))
			upper.append(Vector2(1,2))
			upper.append(Vector2(2,2))
			upper.append(Vector2(1,4))
			
			lower.append(Vector2(1,1))
			lower.append(Vector2(3,1))
			lower.append(Vector2(3,2))
			lower.append(Vector2(3,3))
			lower.append(Vector2(5,2))
	elif lvl == 8:
		half_size =  4

		while upper.size() < half_size:
			
			upper.append(Vector2(0,0))
			upper.append(Vector2(2,0))
			upper.append(Vector2(0,2))
			upper.append(Vector2(1,2))
			
			lower.append(Vector2(1,1))
			lower.append(Vector2(3,1))
			lower.append(Vector2(1,3))
			lower.append(Vector2(2,3))
	elif lvl == 11:
		half_size =  4

		while upper.size() < half_size:
			
			upper.append(Vector2(0,1))
			upper.append(Vector2(0,2))
			upper.append(Vector2(2,2))
			upper.append(Vector2(2,4))
			
			lower.append(Vector2(2,1))
			lower.append(Vector2(2,3))
			lower.append(Vector2(4,0))
			lower.append(Vector2(4,1))
	elif lvl == 14:
		half_size =  5

		while upper.size() < half_size:
			
			upper.append(Vector2(0,1))
			upper.append(Vector2(0,3))
			upper.append(Vector2(0,4))
			upper.append(Vector2(2,4))
			upper.append(Vector2(4,4))
			
			lower.append(Vector2(1,2))
			lower.append(Vector2(1,4))
			lower.append(Vector2(1,5))
			lower.append(Vector2(3,5))
			lower.append(Vector2(4,5))
	else:
		$Label.add_color_override("font_color", Color(0,10,5))
		$Label.text = ""
		var shifted = false
		var change = randi() % 5
		while upper.size() < half_size:
			var random_position = Vector2(randi() % 3 + 1, randi() % (board_size / 2) + 1)
			#print(random_position)
			if upper.find(random_position) == -1:
				upper.append(random_position)

		if change > 3:
			shifted = false
			for dx in range(-5, 6):
				for dy in range(-5, 6):
					if dx == 0 and dy == 0:
						continue 
					if try_shift(Vector2(dx, dy)):
						if not shifted:
							print("смещение(3-4)" + str(Vector2(dx, dy)))
						shifted = true
						break
				if shifted:
					break
			
			if not shifted:
				print("Не удалось найти подходящее смещение для lower.")
				refresh_board()
		else:
			shifted = false
			for dx in range(-1, 3):
				for dy in range(-1, 3):
					if dx == 0 and dy == 0:
						continue 
					if try_shift(Vector2(dx, dy)):
						if not shifted:
							print("смещение(0-3)" + str(Vector2(dx, dy)))
						shifted = true
						break
				if shifted:
					break
			
			if not shifted:
				print("Не удалось найти подходящее смещение для lower.")
				refresh_board()

		
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
	btn_menu.rect_position = Vector2(0, 0)
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
	check_button.connect("pressed", self, "check_result")
	add_child(check_button)
	
func normalize_positions(positions: Array) -> Array:
	if positions.empty():
		return positions
	
	var first_pos = positions[0]
	var normalized_positions = []
	for pos in positions:
		normalized_positions.append(pos - first_pos)
	
	normalized_positions.sort()
	return normalized_positions

func are_shapes_aligned() -> bool:
	var normalized_upper = normalize_positions(upper)
	var normalized_lower = normalize_positions(lower)

	# Проверка на минимальный размер
	if normalized_upper.size() < 2 or normalized_lower.size() < 2:
		return false

	# Проверка симметрии по горизонтальной оси
	var horizontal_symmetry = normalized_upper == normalized_lower

	# Проверка симметрии по вертикальной оси
	var vertical_symmetry = true
	var min_size = min(normalized_upper.size(), normalized_lower.size())
	var remaining_cells = half_size - 1  # Оставшиеся клетки до half_size
	for i in range(min_size):
		if remaining_cells <= 0:
			break
		if normalized_upper[i].x < 0 or normalized_lower[normalized_lower.size() - 1 - i].x < 0:
			continue
		if normalized_upper[i].x != normalized_lower[normalized_lower.size() - 1 - i].x:
			vertical_symmetry = false
			break
		remaining_cells -= 1

	return horizontal_symmetry or vertical_symmetry


func check_result():
		if green_cells_selected < half_size:
			$Label.add_color_override("font_color", Color(0,10,5))
			$Label.text = "Select more cells!"
			return
		if lvl == 2 or lvl == 5 or lvl == 8 or lvl == 11 or lvl == 14:
			if upper.empty() or lower.empty():
				$Label.add_color_override("font_color", Color(5,0,10))
				$Label.text = "All good! LVL " + str(lvl)
				lvl += 1
				refresh_board()
			else:
				$Label.add_color_override("font_color", Color(0,10,5))
				$Label.text = "Try Again :D!"
		else:
			if upper.empty() or lower.empty() or are_shapes_aligned():
				$Label.add_color_override("font_color", Color(5,0,10))
				$Label.text = "All good! LVL " + str(lvl)
				lvl += 1
				refresh_board()
			else:
				$Label.add_color_override("font_color", Color(0,10,5))
				$Label.text = "Try Again :D!"

		
func update_board():
	for child in get_children():
		if child is Button and child.text != "Update" and child.text != "Check" and child.text != "Reset" and child.text != "Menu":
			remove_child(child)
			
	#$Label.text = ""
	$Label.text = "lvl "+ str(lvl)
	#create_board()
	_ready()
	
func reset_board():
	if lvl >=0:
		for child in get_children():
			if child is Button and child.text != "Update" and child.text != "Check" and child.text != "Reset" and child.text != "Menu":
				if child.modulate == Color(1, 0, 0): # Если кнопка красная, меняем ее на зеленую
					if lvl < 3:
						child.modulate = Color(0, 5, 0)
					elif lvl  < 6:
						child.modulate = Color(0, 0, 1) 
					elif lvl  < 9:
						child.modulate = Color(0, 1, 2) 
					elif lvl < 12:
						child.modulate = Color(0, 10, 3) 
						
					var position = (child.rect_position - board_offset) / 70
					if copy_upper.find(position) != -1:
						upper.append(position)  # Возвращаем копию исходного массива
#			
					elif copy_lower.find(position) != -1:
						lower.append(position)
#					
	green_cells_selected = 0
	$Label.text = ""
	print("Карта обновлена")
