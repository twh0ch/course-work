from godot import exposed, export
from godot import *


@exposed
class equal(Control):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		self.matrix = self.generate_random_matrix()
		self.draw_matrix(self.matrix)

	def generate_random_matrix(self):
		matrix = [[0 for _ in range(GRID_SIZE)] for _ in range(GRID_SIZE)]
		for _ in range(GRID_SIZE + 1):  # 6 единиц в матрице
			row, col = random.randint(0, GRID_SIZE - 1), random.randint(0, GRID_SIZE - 1)
			matrix[row][col] = 1
		return matrix

	def draw_matrix(self, matrix):
		for row in range(GRID_SIZE):
			for col in range(GRID_SIZE):
				if matrix[row][col] == 1:
					color = Color(0, 0, 255)  # Синий цвет
				else:
					color = Color(1, 1, 1)  # Белый цвет
				self.get_node("CanvasLayer/Control").draw_rect(Rect2(col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE), color)
				self.get_node("CanvasLayer/Control").draw_rect(Rect2(col * CELL_SIZE, row * CELL_SIZE, CELL_SIZE, CELL_SIZE), Color(0, 0, 0), 1)  # Чёрная рамка


	def check_symmetry(self, matrix):
		n = len(matrix)
		m = len(matrix[0])

		# Проверка на симметричность по горизонтали и вертикали
		flipped_horizontal = [row[::-1] for row in matrix]
		flipped_vertical = matrix[::-1]
		if matrix == flipped_horizontal or matrix == flipped_vertical:
			return True

		# Проверка симметричности после поворота на 90 градусов
		rotated_matrix = [[matrix[j][i] for j in range(n)] for i in range(m - 1, -1, -1)]
		if rotated_matrix == flipped_horizontal or rotated_matrix == flipped_vertical:
			return True

		# Проверка симметричности после сдвигов вправо и вниз
		for i in range(n):
			for j in range(m):
				if matrix == [[flipped_horizontal[k][l] for l in range(m)] for k in range(i, n)] or \
				matrix == [[flipped_vertical[k][l] for l in range(m)] for k in range(j, m)]:
					return True

		# Проверка симметричности после смещений влево и вверх
		for i in range(n):
			for j in range(m):
				if matrix == [[flipped_horizontal[k][l] for l in range(m)] for k in range(0, i)] or \
				matrix == [[flipped_vertical[k][l] for l in range(m)] for k in range(0, j)]:
					return True

		return False

	@exposed
	def _on_Control_gui_input(self, event):
		if event.is_action_pressed("ui_click"):
			position = event.position
			row = int(position.y // CELL_SIZE)
			col = int(position.x // CELL_SIZE)
			self.matrix[row][col] = 1 - self.matrix[row][col]
			self.draw_matrix(self.matrix)
			if self.check_symmetry(self.matrix):
				self.get_node("Label").text = "Поздравляем! Фигура стала симметричной."
				# Здесь можно добавить код для перехода на следующую сцену
				get_tree().change_scene("res://next_scene.tscn")  # Замените "res://next_scene.tscn" на путь к вашей следующей сцене


GRID_SIZE = 5
CELL_SIZE = 50
