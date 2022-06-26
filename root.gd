extends Node2D

var tile_set = preload("res://asset/root.tres")

var number_of_itaration = 1

var used_cells : Array

func save_file_img(content:Image):
	content.save_png("res://")

func make_image(_used_cells : Array):
	var color_black := Color.black
	var color_white := Color.white
	var image = Image.new()
	image.create(OS.window_size.x+1,OS.window_size.y+1,false,Image.FORMAT_RGBA5551)
	image.lock()
	for element in _used_cells:
		if element[2] == 0:
			image.set_pixel(element[0],element[1],color_white)
		elif element[2] == 1:
			image.set_pixel(element[0],element[1],color_black)
		else:
			print_debug("DEBUG: color_value in used_cells unknown = ",element[2])
	image.unlock()
	save_file_img(image)

func set_tile_map(array: Array,tile_map:TileMap):
	# print_debug("DEBUG: tile_map updated")
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
	used_cells = []
	print_debug("DEBUG: initial used_cells size ",len(used_cells))
	# print_debug("DEBUG: fix_map")
	for a in range(1,number_of_column+1):
		for b in range(1,number_of_row+1):
			var number_of_white = 0
			for x in range(b-1,b+2):
				for y in range(a-1,a+2):
					if tile_map.get_cell(x,y) == 1: # can't change it
						number_of_white+=1
			# 1,0 -> black,white
			if number_of_white >= 4:
				used_cells.append([b,a,0])
			else:
				used_cells.append([b,a,1])
	print_debug("DEBUG final used_cells size ",len(used_cells))

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
	# print_debug("DEBUG used_cells size",len(used_cells))
	while itaration <= number_of_itaration:
		print("DEBUG: ******************** itaration = ",itaration)
		itaration+=1
		fix_map(number_of_row,number_of_column,tile_map)
		set_tile_map(used_cells,tile_map)
		# make_image(used_cells)
		used_cells = []
