extends Control

func _ready():
	set_size(Vector2(576, 1024))
	
	var vbox = VBoxContainer.new()
	vbox.set_anchor_and_margin(MARGIN_TOP, 1, 0)
	vbox.set_anchor_and_margin(MARGIN_LEFT, 1, 0) 
	add_child(vbox)
	
	#!!!!!!!!!!!!
	#
	#просто прикрепляем   отдельно к каждой сцене скрипт
	#и подгружаем сцену уже с встроенным в нее скриптом
	#
	#!!!!!!!!!!!
	
	#ШРИФТ И РАЗМЕР 
	var custom_font = DynamicFont.new()
	custom_font.font_data = preload("res://Fonts/acumin-pro(VER).ttf")
	custom_font.size = 40
	
	var custom_style = StyleBoxFlat.new()
	custom_style.bg_color = Color(0, 0, 1)
	
	var btn_menu = Button.new()
	btn_menu.add_font_override("font", custom_font)
	btn_menu.text = "Back"

	btn_menu.add_stylebox_override("normal", custom_style)
	btn_menu.add_stylebox_override("hover", custom_style)
	btn_menu.add_stylebox_override("pressed", custom_style)

	btn_menu.rect_min_size = Vector2(300, 70)
	btn_menu.set_position(Vector2(225, 600))

	btn_menu.add_color_override("font_color", Color(1, 1, 1))  # Устанавливаем белый цвет текста

	btn_menu.connect("pressed", self, "_on_button_pressed", [load("res://Scenes/Game.tscn")])

	add_child(btn_menu)
	
	
	var btn_scene1 = Button.new()
	btn_scene1.add_font_override("font", custom_font)
	btn_scene1.text = "Symmetric"

	btn_scene1.add_stylebox_override("normal", custom_style)
	btn_scene1.add_stylebox_override("hover", custom_style)
	btn_scene1.add_stylebox_override("pressed", custom_style)

	btn_scene1.rect_min_size = Vector2(300, 70)
	btn_scene1.set_position(Vector2(225, 300))

	btn_scene1.add_color_override("font_color", Color(1, 1, 1))  # Устанавливаем белый цвет текста

	btn_scene1.connect("pressed", self, "_on_button_pressed", [preload("res://Scenes/equal.tscn")])

	add_child(btn_scene1)
	
	var btn_scene2 = Button.new()
	btn_scene2.add_font_override("font", custom_font)
	btn_scene2.text = "Similar"
	btn_scene2.add_stylebox_override("normal", custom_style)
	btn_scene2.add_stylebox_override("hover", custom_style)
	btn_scene2.add_stylebox_override("pressed", custom_style)

	btn_scene2.rect_min_size = Vector2(300, 70)
	btn_scene2.set_position(Vector2(225, 450))

	btn_scene2.add_color_override("font_color", Color(1, 1, 1))  # Устанавливаем белый цвет текста

	btn_scene2.connect("pressed", self, "_on_button_pressed", [preload("res://Scenes/equal1.tscn")])

	add_child(btn_scene2)
	
func _on_button_pressed(scene_to_load):
	for child in get_children():
		child.queue_free()
		
	print("Loading scene:", scene_to_load)
	var scene_instance = scene_to_load.instance()
	add_child(scene_instance)
