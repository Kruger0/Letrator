

/*
function create_tdext_sys(_string, _sep, _w, _color, _alpha) constructor {
	static text_sys_counter = 0;
	text_sys_counter++;
	
	str_size = string_length(_string)
	var _letterSize = string_width("B")
	
	
	letter_grid = ds_grid_create(str_size+1, STR_ARG_COUNT)
	//worlds_grid = ds_grid_create(2, 400)
	
	//popula a lista com cada letra e cada metadata
	for (var c = 1; c < str_size; c++) {
		var _char = string_copy(_string, c, 1)
		
		ds_grid_add(letter_grid, c, str.char,	_char)
		ds_grid_add(letter_grid, c, str.x,		0)
		ds_grid_add(letter_grid, c, str.y,		0)
		ds_grid_add(letter_grid, c, str.xscal,	1)
		ds_grid_add(letter_grid, c, str.yscal,	1)
		ds_grid_add(letter_grid, c, str.ang,	0)
		ds_grid_add(letter_grid, c, str.col,	_color)
		ds_grid_add(letter_grid, c, str.alpha,	_alpha)
	}
	//Draw the text
	draw = function(_x, _y) {
		
		var _str_len = ds_grid_width(letter_grid)
		var g = letter_grid
		for (var i = 1; i < _str_len; i++) {
			draw_text_transformed_color(
			_x + g[# i, str.x], 
			_y + g[# i, str.y], 
			g[# i, str.char], 
			g[# i, str.xscal], 
			g[# i, str.yscal], 
			g[# i, str.ang], 
			g[# i, str.col], 
			g[# i, str.col], 
			g[# i, str.col], 
			g[# i, str.col], 
			g[# i, str.alpha]);
		}
	}
	
	//Update effects
	
	//Typewriter
	applying_fx = true
	current_letter = 1
	typewriter_letter_progress = 0
	type_writer_speed = 0.1
	y_anim_offset = 1
	
	static typewriter = function() {
		if (current_letter < str_size) {
			if (typewriter_letter_progress >= 1) {
				typewriter_letter_progress = 0
				current_letter = clamp(current_letter+1, 0, str_size)
			} else {
				typewriter_letter_progress += type_writer_speed
			}
		} else {
			applying_fx = false
		}
		
		if (applying_fx) {
			letter_grid[# current_letter, str.alpha] = typewriter_letter_progress
			//letter_grid[# current_letter, str.y ] -= typewriter_letter_progress*2
			//letter_grid[# 5, str.x ] = lerp(0, irandom_range(-4,4), .2)
			//letter_grid[# 5, str.y ] = lerp(0, irandom_range(-4,4), .2)
			letter_grid[# current_letter, str.xscal ] = typewriter_letter_progress
			letter_grid[# current_letter, str.yscal ] = typewriter_letter_progress
		}
	}
}
