extends Node2D

var tile_set = preload("res://asset/root.tres")

var number_of_itaration = 10

var used_cells : Array

func make_image():
	var color_map = 0
	var image_texture : ImageTexture = ImageTexture.new()
	image_texture.create(OS.window_size.x,OS.window_size.y,Image.FORMAT_L8)

func set_tile_map(array: Array,tile_map:TileMap):
	print_debug("DEBUG: tile_map updated")
	for element in array:
		tile_map.set_cell(element[0],element[1],element[2])

func generate_init_map(number_of_row : int ,number_of_column : int) -> void:
	for x in range(0,number_of_row):
		for y in range(0,number_of_column):
			# 1,0 -> black,white
			if int(randf() * 100) < 60:
				used_cells.append([x,y,0])
			else:
				used_cells.append([x,y,1])
	# print_debug("DEBUG: used_cells = ",used_cells)

func fix_map(number_of_row:int,number_of_column:int,tile_map:TileMap) -> void:
	print_debug("DEBUG: fix_map")
	used_cells = []
	for a in range(1,number_of_column+1):
		for b in range(1,number_of_row+1):
			var number_of_white = 0
			for x in range(a-1,a+2):
				for y in range(b-1,b+2):
					if tile_map.get_cell(x,y) == 1: # can't change it
						number_of_white+=1
			# 1,0 -> black,white
			if number_of_white >= 4:
				used_cells.append([a,b,0])
			else:
				used_cells.append([a,b,1])

func _ready() -> void:
	var tile_map : TileMap = $TileMap
	var number_of_column : int = int((OS.window_size.y) / tile_map.get_cell_size().x) + 1
	var number_of_row : int = int((OS.window_size.x) / tile_map.get_cell_size().y) + 1
	var itaration : int = 0
	
	print_debug("DEBUG: window_size = ", OS.window_size)
	print_debug("DEBUG: cell_size = ", tile_map.get_cell_size())
	print_debug("DEBUG: num_row, num_column = ", number_of_row, ", " ,number_of_column)
	
	randomize()
	generate_init_map(number_of_row,number_of_column)
	set_tile_map(used_cells,tile_map)
	while itaration <= number_of_itaration:
		print("DEBUG: itaration = ",itaration)
		itaration+=1
		fix_map(number_of_row,number_of_row,tile_map)
		set_tile_map(used_cells,tile_map)
		used_cells = []
