/*
sintaxe 
[* ]

function: [*function()]

//funçoes genericas, se misturam, e possuem historico

rgb(255,255,255) <- setar cor rgb
hsv(255,255,255) <- setar cor com hsv
color(c_white <- gm constant) <- setar cor com constantes do game maker
alpha(1) <- definir alpha
font(fnt_name) <- definir fonte

cc() <- limpar cor setada
ca() <- limpar alpha setado
cf() <- limpar fonte setada

cca() <- limpar todo historico de cor
caa() <- limpar todo historico de alpha
cfa() <- limpar todo historico de fonte


//funçoes que se sobrepoem e nao possuem historico

rainbow(5) 
cr() <- clear rainbow

wave()
cw()

dealpha(1.0, 0.5) <- degrade de alpha

cdea() <- limpa o degrade de alpha




///em breve
decolor(c_pink, c_blue) <- degrade de cor
cdec() <- limpar degrade de cor

//especial
br() //quebra linha
spr(spr, sub, animation, width, height)


//essas funçoes sao para serem usadas exclusivamente para textos em dialogos
a_cs(<state>) // char state
a_cii(<index>) // char image index
a_cis(<speed>) // char image speed

*/ 

function ts_create_text(_font_default, _string, is_monospace = -1) {
	
	draw_set_font(_font_default)
	var _default_font = draw_get_font()
	
	var _line_info = function(width, height) constructor {
		line_width = width
		line_height = height
	}
	var _struct = {
		text : "",
		line_infos : [],
		functions : [],
		
		//funçoes de cache
		functions_cache : [],
		line_infos_cache : [],
		
		monospace : is_monospace,
	}
	
	var _brackets_open = false;
	
	var _font_selected = -1, _line_width = 0, _line_height = 0;
	for(var _ch = 1; _ch <= string_length(_string); _ch++){
		var _char = string_char_at(_string,_ch);
		var _next_char = string_char_at(_string,_ch+1);
		
		if(_char == "[" && _next_char == "*") {
			_brackets_open = true; 
			
			//prepara o lugar para guardar os valores
			var _index_function = array_length(_struct.functions)
			array_push(_struct.functions, {
				function_name : "",
				arguments : [],
				index : 0,
				variables : {},
			})
			
			//aqui le a funçao e guarda na variavel "_function"
			var _function = ""
			for(var _chf = _ch+2; _chf <= string_length(_string); _chf++){
				var _char = string_char_at(_string,_chf);
				if(_char == "]") {
					_ch = _chf
					break;
				}
				if(_char != " "){
					_function += _char;
				}
			}
			
			//pega o nome da funçao
			var _function_name = ""
			for(var _chfn = 1; _chfn <= string_length(_function); _chfn++){
				var _char = string_char_at(_function,_chfn);
				if(_char == "("){
					break;
				} else {
					_function_name += _char
				}
			}
			
			//pega os argumentos da funçao
			var _reading_arguments = false;
			var _arguments = []
			var _arguments_arr_index = 0;
			for(var _chfa = 1; _chfa <= string_length(_function); _chfa++){
				var _char = string_char_at(_function,_chfa);
				if(_char == ")"){
					break
				}
				if(_reading_arguments) {
					if(_char = ","){
						_arguments_arr_index += 1;
					} else {
						if(array_length(_arguments) <= _arguments_arr_index){
							_arguments[@ _arguments_arr_index] = "";
						}
						_arguments[@ _arguments_arr_index] += _char
					}
				}
				if(_char == "("){
					_reading_arguments = true;
				} 
			} 
			
			//guarda as informaçoes
			_struct.functions[@ _index_function].function_name = _function_name;
			_struct.functions[@ _index_function].arguments = _arguments;
			_struct.functions[@ _index_function].index = string_length(_struct.text)+1
			
			//checa se é uma das funçoes q guardam valores ou que precisam mudar os argumentos
			switch(_function_name) {
				case "br": 
					array_push(_struct.line_infos, new _line_info(_line_width, _line_height))
					_line_width = 0;
					_line_height = 0;
				break;
				case "rbg":
					for(var _carg = 0; _carg < array_length(_struct.functions[@ _index_function].arguments); _carg++){
						_struct.functions[@ _index_function].arguments[@ _carg] = real(_struct.functions[@ _index_function].arguments[@ _carg]);
					}
				break;
				case "font":
					_struct.functions[@ _index_function].arguments[@ 0] = asset_get_index(_struct.functions[@ _index_function].arguments[@ 0])
				break;
				case "alpha":  
					_struct.functions[@ _index_function].arguments = [real(_struct.functions[@ _index_function].arguments[0])]
				break;
				case "color":
					var _set_arr = []
					switch(_struct.functions[@ _index_function].arguments[0]) { 
						case "c_aqua": _set_arr = [c_aqua] break;
						case "c_black": _set_arr = [c_black] break;
						case "c_blue": _set_arr = [c_blue] break;
						case "c_dkgray": _set_arr = [c_dkgray] break;
						case "c_fuchsia": _set_arr = [c_fuchsia] break;
						case "c_gray": _set_arr = [c_gray] break;
						case "c_green": _set_arr = [c_green] break;
						case "c_lime": _set_arr = [c_lime] break;
						case "c_ltgray": _set_arr = [c_ltgray] break;
						case "c_maroon": _set_arr = [c_maroon] break;
						case "c_navy": _set_arr = [c_navy] break;
						case "c_olive": _set_arr = [c_olive] break;
						case "c_orange": _set_arr = [c_orange] break;
						case "c_purple": _set_arr = [c_purple] break;
						case "c_red": _set_arr = [c_red] break;
						case "c_silver": _set_arr = [c_silver] break;
						case "c_teal": _set_arr = [c_teal] break;
						case "c_white": _set_arr = [c_white] break;
						case "c_yellow": _set_arr = [c_yellow] break;
					}
					_struct.functions[@ _index_function].arguments = _set_arr
				break;
				case "rainbow": 
					_struct.functions[@ _index_function].arguments = [real(_struct.functions[@ _index_function].arguments[0])]
					_struct.functions[@ _index_function].variables = {
						red : 255,
						blue : 0,
						green : 0,
						state : 0,
					}
				break;
				case "spr":
					_struct.functions[@ _index_function].arguments[@ 1] = real(_struct.functions[@ _index_function].arguments[@ 1])
					_struct.functions[@ _index_function].arguments[@ 2] = bool(_struct.functions[@ _index_function].arguments[@ 2])
					_struct.functions[@ _index_function].arguments[@ 3] = real(_struct.functions[@ _index_function].arguments[@ 3])
					_struct.functions[@ _index_function].arguments[@ 4] = real(_struct.functions[@ _index_function].arguments[@ 4])
					
					_struct.functions[@ _index_function].arguments[@ 0] = asset_get_index(_struct.functions[@ _index_function].arguments[@ 0]) 
					
					if(_struct.functions[@ _index_function].arguments[@ 3]==-1) {
						_struct.functions[@ _index_function].arguments[@ 3] = sprite_get_width(_struct.functions[@ _index_function].arguments[@ 0])
					}
					if(_struct.functions[@ _index_function].arguments[@ 4]==-1) {
						_struct.functions[@ _index_function].arguments[@ 4] = sprite_get_height(_struct.functions[@ _index_function].arguments[@ 0])
					}
					if(_struct.functions[@ _index_function].arguments[@ 2]) {
						_struct.functions[@ _index_function].variables = {
							index : _struct.functions[@ _index_function].arguments[@ 0],
							number : sprite_get_number(_struct.functions[@ _index_function].arguments[@ 0]),
							img_speed : sprite_get_speed(_struct.functions[@ _index_function].arguments[@ 0]), 
						}
					} else {
						_struct.functions[@ _index_function].variables = {
							index : _struct.functions[@ _index_function].arguments[@ 2],
						}
					}
				
				break;
				case "wave":
					//primeiro pega o tamanhod a string afetada pelo wave
					var _valid_string = ""
					var _tbrackets_open = false;
					var _wave_closed = 0
					
					var _indece_start = 0;
					for(var _sin = _ch; _sin < string_length(_string); _sin++) {
						var _schar = string_char_at(_string,_sin)
						if(_schar == "]") {
							_indece_start = _sin+1
							break;
						}
					}
					for(var _tch = _indece_start; _tch < string_length(_string); _tch++){ 
						var _tchar = string_char_at(_string,_tch);
						var _next_tchar = string_char_at(_string,_tch+1);
						
						if(!_tbrackets_open) {
							if(_tchar == "[" && _next_tchar == "*") {
								_tbrackets_open = true; 
								_tch += 2;
							} else {
								_valid_string += _tchar
							}
						} else {
							var _tfn = ""
							for(var _tfch = _tch-1; _tfch < string_length(_string); _tfch++) {
								var _tfnchar = string_char_at(_string,_tfch)
								if(_tfnchar == "(") {
									break;
								}
								_tfn += _tfnchar
							} 
							switch(_tfn) {
								case "wave":
									_wave_closed -= 1;
								break;
								case "cw":
									_wave_closed += 1;
								break;
							}
							if(_wave_closed >= 1) {
								break;
							}
							if(_tchar == "]") {
								_tbrackets_open = false
							}
						}
					}
					_struct.functions[@ _index_function].variables = {
						length : string_length(_valid_string),
						angle : 0,
						olds_sin : [],
						set_sin : [],
					} 
					for(var _ap = 0; _ap < _struct.functions[@ _index_function].variables.length; _ap++) {
						_struct.functions[@ _index_function].variables.angle += 15;
						var _sin = dsin(_struct.functions[@ _index_function].variables.angle)
						array_push(_struct.functions[@ _index_function].variables.olds_sin, _sin)
						array_push(_struct.functions[@ _index_function].variables.set_sin, _sin)
					} 
				break;
				case "a_cs":
					_struct.functions[@ _index_function].variables = _struct.functions[@ _index_function].arguments[@ 0]
				break;
				case "a_cii":
					_struct.functions[@ _index_function].variables = real(_struct.functions[@ _index_function].arguments[@ 0])
				break;
				case "a_cis":
					_struct.functions[@ _index_function].variables = real(_struct.functions[@ _index_function].arguments[@ 0])
				break;  
			}
		} else {
			//aqui só os caracteres validos sao incluidos
			_struct.text += _char
			if(_font_selected == -1) {
				_line_width += string_width(_char)
				if(string_height(_char) > _line_height) {
					_line_height = string_height(_char)
				}
			}
		}
		
	}
	//if(_line_width != 0 && _line_height != 0) {
	array_push(_struct.line_infos, new _line_info(_line_width, _line_height))
	//}
	
	draw_set_font(_default_font) 
	
	return _struct
}





function ts_internal_broken_line(_st, _sep,_w) {
	_st.functions_cache = [];
	_st.line_infos_cache = []
	var _default_font = draw_get_font()
	
	var _font_list = [];
	//separa as palavras 
	var _line_width = 0;
	var _line_height = 0;
	for(var _i = 1; _i <= string_length(_st.text); _i++) {
		var _char = string_char_at(_st.text, _i);
		for(var _fnt = 0; _fnt < array_length(_st.functions); _fnt++){
			//se esta no indice que a funçao foi marcada para ser chamada ent inicia
			if(_st.functions[@ _fnt].index == _i){
				switch(_st.functions[@ _fnt].function_name) {
					case "br": 
						_line_width = 0
					break;
					case "font": //setar uma fonte 
						array_push(_font_list, _st.functions[@ _fnt].arguments[@ 0])
						draw_set_font(_font_list[@ array_length(_font_list)-1])
					break;
					case "cf": //limpar ultima fonte selecionada
						array_pop(_font_list)
						if(array_length(_font_list) != 0) {
							draw_set_font(_font_list[@ array_length(_font_list)-1])
						} else {
							draw_set_font(_default_font)
						}
					break;
				}
			}
		}
		if(string_height(_char) > _line_height) {
			_line_height = string_height(_char)
		}
		if(_char != " "){
			_line_width += string_width(_char) 
		} else {
			//pega a proxima palavra
			var _next_word_width = 0;
			var _start = false;
			for(var _fnw = _i+1; _fnw <= string_length(_st.text); _fnw++) {
				var _next_char = string_char_at(_st.text, _fnw);
				if(!_start) {
					if(_next_char != " ") {
						_start = true;
					}
				} 
				if(_start) {
					if(_next_char == " ") {
						break;
					} else {
						_next_word_width += string_width(_next_char)
					}
				}
			}
			if(_line_width+_next_word_width+string_width(" ") >= _w) { 
				//_line_width += string_width(_char)
				array_push(_st.functions_cache, {
					function_name : "br",
					arguments : [],
					index : _i+1,
				}) 
				array_push(_st.line_infos_cache, {
					line_width : _line_width,
					line_height : _sep,
				})
				_line_width = 0;
				//_line_width += string_width(" ");
				//_i += 1;
			} else {
				_line_width += string_width(" ");
			}
		}
	}
	array_push(_st.line_infos_cache, {
		line_width : _line_width,
		line_height : _line_height,
	})
 
	draw_set_font(_default_font);
}

function ts_draw_text_ext(_x,_y,_st,_sep,_w) {  
	ts_internal_broken_line(_st,_sep,_w)
	
	ts_draw_text(_x, _y, _st)
}

function ts_draw_text(_x, _y, _st) {
	var _default_color, _default_alpha, _default_font;
	_default_color = draw_get_color()
	_default_alpha = draw_get_alpha()
	_default_font = draw_get_font()
	
	var _default_halign, _default_valign;
	_default_halign = draw_get_halign();
	_default_valign = draw_get_valign();
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	
	var _color_list, _alpha_list, _font_list;
	_color_list = []
	_alpha_list = []
	_font_list = []
	
	//se é monospace
	var _monospace = _st.monospace
	//sistemas ativos
	var _rainbow = {
		active : false,
		rgb : 0,
	}
	var _wave = {
		active : false,
		arr_set : [],
		arr_set_index_ignore : 0,
	}
	
	var _index_search_function = 0;
	
	var _max_width_line = 0;
	for(var _ln = 0; _ln < array_length(_st.line_infos); _ln++) {
		if(_st.line_infos[_ln].line_width>_max_width_line) {
			_max_width_line = _st.line_infos[_ln].line_width
		}
	}
	
	var _lines_broken = 0;
	var _lines_broken_cache = 0;
	var _x_draw = _x
	var _y_draw = _y  
	
	if(array_length(_st.line_infos) > 1) {
		switch(_default_halign) {
			case fa_center: _x_draw = _x - _st.line_infos[_lines_broken].line_width/2; break;
			case fa_right: _x_draw = _x - _st.line_infos[_lines_broken].line_width; break;
		}  
	} else {
		switch(_default_halign) {
			case fa_center: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache].line_width/2; break;
			case fa_right: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache].line_width; break;
		}  
	}
	
	switch(_default_valign) {
		case fa_center: _y_draw += 10; break; 
		case fa_bottom: _y_draw += 20; break; 
	}
	
	for(var _ln = 0; _ln < array_length(_st.line_infos); _ln++) {
		switch(_default_valign) {
			case fa_center: _y_draw -= _st.line_infos[_ln].line_height/2; break;
			case fa_bottom: _y_draw -= _st.line_infos[_ln].line_height; break;
		}  
	}
	
	for(var _ln = 0; _ln < array_length(_st.line_infos_cache); _ln++) {
		switch(_default_valign) {
			case fa_center: _y_draw -= _st.line_infos_cache[_ln].line_height/2; break;
			case fa_bottom: _y_draw -= _st.line_infos_cache[_ln].line_height; break;
		}  
	}
			
	for(var _ch = 1; _ch <= string_length(_st.text); _ch++){
		var _char = string_char_at(_st.text,_ch)
		 
		//interpreta a funçao de chace
		for(var _fnt = 0; _fnt < array_length(_st.functions_cache); _fnt++){
			if(_st.functions_cache[@ _fnt].index == _ch){
				switch(_st.functions_cache[@ _fnt].function_name) {
					case "br": 
						switch(_default_halign) {
							case fa_left: _x_draw = _x; break;
							case fa_center: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache+1].line_width/2; break;
							case fa_right: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache+1].line_width; break;
						}
						switch(_default_valign) {
							case fa_top: _y_draw += _st.line_infos_cache[_lines_broken_cache+1].line_height; break;
							case fa_center: _y_draw += _st.line_infos_cache[_lines_broken_cache].line_height; break;
							case fa_bottom: _y_draw += _st.line_infos_cache[_lines_broken_cache+1].line_height; break;
						}  
						_lines_broken_cache += 1; 
					break;
				}
			}
		}
		//interpreta a funçao
		for(var _fnt = _index_search_function; _fnt < array_length(_st.functions); _fnt++){
			//se esta no indice que a funçao foi marcada para ser chamada ent inicia
			if(_st.functions[@ _fnt].index == _ch){
				switch(_st.functions[@ _fnt].function_name) {
					case "br": 
						if(_lines_broken+1 <= array_length(_st.line_infos)-2 || array_length(_st.line_infos_cache) == 0) { 
							switch(_default_halign) {
								case fa_left: _x_draw = _x; break;
								case fa_center: _x_draw = _x - _st.line_infos[_lines_broken+1].line_width/2; break;
								case fa_right: _x_draw = _x - _st.line_infos[_lines_broken+1].line_width; break;
							}
							switch(_default_valign) {
								case fa_top: _y_draw += _st.line_infos[_lines_broken+1].line_height; break;
								case fa_center: _y_draw += _st.line_infos[_lines_broken].line_height; break;
								case fa_bottom: _y_draw += _st.line_infos[_lines_broken+1].line_height; break;
							}  
						} else {
							switch(_default_halign) {
								case fa_left: _x_draw = _x; break;
								case fa_center: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache+1].line_width/2; break;
								case fa_right: _x_draw = _x - _st.line_infos_cache[_lines_broken_cache].line_width; break;
							}
							switch(_default_valign) {
								case fa_top: _y_draw += _st.line_infos_cache[_lines_broken_cache+1].line_height; break;
								case fa_center: _y_draw += _st.line_infos[_lines_broken].line_height; break;
								case fa_bottom: _y_draw += _st.line_infos_cache[_lines_broken_cache+1].line_height; break;
							} 
						}
						_lines_broken += 1; 
					break;
					case "color":
						array_push(_color_list, _st.functions[@ _fnt].arguments[@ 0])
						draw_set_color(_color_list[@ array_length(_color_list)-1])
					break;
					case "rgb":
						var _r, _g, _b;
						_r = _st.functions[@ _fnt].arguments[@ 0]
						_g = _st.functions[@ _fnt].arguments[@ 1]
						_b = _st.functions[@ _fnt].arguments[@ 2]
						var _color = make_color_rgb(_r,_g,_b)
						
						array_push(_color_list, _color)
						draw_set_color(_color_list[@ array_length(_color_list)-1])
					break;
					case "cc":
						array_pop(_color_list)
						if(array_length(_color_list) != 0) {
							draw_set_color(_color_list[@ array_length(_color_list)-1])
						} else {
							draw_set_color(_default_color)
						}	
					break;
					case "cca":
						_color_list = []
						draw_set_color(_default_color)
					break;
					
					case "alpha": // setar alpha
						array_push(_alpha_list,	_st.functions[@ _fnt].arguments[@ 0])
						draw_set_alpha(_alpha_list[@ array_length(_alpha_list)-1])
					break;
					case "ca": //limpar as infos do ultimo alpha
						array_pop(_alpha_list)
						if(array_length(_alpha_list) != 0) {
							draw_set_alpha(_alpha_list[@ array_length(_alpha_list)-1])
						} else {
							draw_set_alpha(_default_alpha)
						}
					break;
					case "caa": //limpar totalmente o historico de alpha
						_alpha_list = []
						draw_set_alpha(_default_alpha)
					break;
					
					case "font": //setar uma fonte 
						array_push(_font_list, _st.functions[@ _fnt].arguments[@ 0])
						draw_set_font(_font_list[@ array_length(_font_list)-1])
					break;
					case "cf": //limpar ultima fonte selecionada
						array_pop(_font_list)
						if(array_length(_font_list) != 0) {
							draw_set_font(_font_list[@ array_length(_font_list)-1])
						} else {
							draw_set_font(_default_font)
						}
					break;
					case "cfa": //limpar o historico de fontes selecionas
						_font_list = []
						draw_set_font(_default_font)
					break;
					
					
					case "rainbow":
						_rainbow.active = true;
						var _p = _st.functions[@ _fnt].arguments[@ 0]
						var _r, _g, _b;
						_r = _st.functions[@ _fnt].variables.red
						_g = _st.functions[@ _fnt].variables.green
						_b = _st.functions[@ _fnt].variables.blue
						//repeat(real(_st.functions[@ _fnt].arguments[@ 0])) {
							switch(_st.functions[@ _fnt].variables.state) {
								case 0:
									_st.functions[@ _fnt].variables.red -= _p;
									_st.functions[@ _fnt].variables.green += _p; 
									
									_st.functions[@ _fnt].variables.red = clamp(_st.functions[@ _fnt].variables.red, 0, 255)
									_st.functions[@ _fnt].variables.green = clamp(_st.functions[@ _fnt].variables.green, 0, 255)
									if(_st.functions[@ _fnt].variables.red==0) {
										_st.functions[@ _fnt].variables.state = 1
									}
								break;
								case 1:
									_st.functions[@ _fnt].variables.green -= _p;
									_st.functions[@ _fnt].variables.blue += _p;
									
									_st.functions[@ _fnt].variables.green = clamp(_st.functions[@ _fnt].variables.green, 0, 255)
									_st.functions[@ _fnt].variables.blue = clamp(_st.functions[@ _fnt].variables.blue, 0, 255)
									if(_st.functions[@ _fnt].variables.green==0) {
										_st.functions[@ _fnt].variables.state = 2
									}
								break;
								case 2:
									_st.functions[@ _fnt].variables.blue -= _p;
									_st.functions[@ _fnt].variables.red += _p;
									
									_st.functions[@ _fnt].variables.blue = clamp(_st.functions[@ _fnt].variables.blue, 0, 255)
									_st.functions[@ _fnt].variables.red = clamp(_st.functions[@ _fnt].variables.red, 0, 255)
									if(_st.functions[@ _fnt].variables.blue==0) {
										_st.functions[@ _fnt].variables.state = 0
									}
								break;
							} 
						//}
						_rainbow.rgb = make_color_rgb(
						_st.functions[@ _fnt].variables.red,
						_st.functions[@ _fnt].variables.green,
						_st.functions[@ _fnt].variables.blue)
						
						draw_set_color(_rainbow.rgb)
					break;
					case "cr":
						_rainbow.active = false
						if(array_length(_color_list) != 0) {
							draw_set_color(_color_list[@ array_length(_color_list)-1])
						} else {
							draw_set_color(_default_color)
						}
					break;
					
					
					
					case "wave":
						_wave.active = true;
						
						var _all_correct = noone
						for(var _ap = 0; _ap < _st.functions[@ _fnt].variables.length; _ap++) { 
							
							var _dest_sin, _set_sin;
							_dest_sin = _st.functions[@ _fnt].variables.olds_sin[@ _ap]
							_set_sin = _st.functions[@ _fnt].variables.set_sin[@ _ap]
							_st.functions[@ _fnt].variables.set_sin[@ _ap] = lerp(_set_sin, _dest_sin*2, 0.1)
							
							if(abs(_set_sin) >= abs(_dest_sin)) { 
								if(_all_correct == noone) {
									_all_correct = true;
								}
							} else {
								_all_correct = false
							}
						}
						if(_all_correct) {
							for(var _rap = 0; _rap < _st.functions[@ _fnt].variables.length; _rap++) { 
								_st.functions[@ _fnt].variables.angle += 15;
								var _sin = dsin(_st.functions[@ _fnt].variables.angle) 
								_st.functions[@ _fnt].variables.olds_sin[@ _rap] = _sin
							}
						}
						
						_wave.arr_set = _st.functions[@ _fnt].variables.set_sin 
						_wave.arr_set_index_ignore = _ch 
					break;
					
					case "cw":
						_wave.active = false 
					break;
					
					
					case "spr":
						var _spr, _sub, _w, _h
						_spr = _st.functions[@ _fnt].arguments[@ 0]
						_sub = floor(_st.functions[@ _fnt].variables.index)
						_w = _st.functions[@ _fnt].arguments[@ 3]
						_h = _st.functions[@ _fnt].arguments[@ 4]
						
						if(_st.functions[@ _fnt].arguments[@ 2]) { 
							if(_st.functions[@ _fnt].variables.index >= _st.functions[@ _fnt].variables.number){
								_st.functions[@ _fnt].variables.index = 0;
							}
							_st.functions[@ _fnt].variables.index += 0.1
						}
						 
						var _xs, _ys;
						_xs = _w/sprite_get_width(_spr)
						_ys = _h/sprite_get_height(_spr)
					 
						var _c, _a;
						_c = c_white
						_a = 1
						
						if(array_length(_alpha_list) != 0) {
							_a = _alpha_list[@ array_length(_alpha_list)-1]
						} 
						if(array_length(_color_list) != 0) {
							_c = _color_list[@ array_length(_color_list)-1]
						}
						
						draw_sprite_ext(_spr, _sub, _x_draw, _y, _xs, _ys, 0, _c, _a)
						_x_draw += _w
					break;
				}
				//muda o index de procura para ignorar esse item
				//pois ele ja foi chamado
				_index_search_function++;
			}
		}
		
		//seta as infos     
		var _wave_y = 0;
		if(_wave.active) {
			var _value = _wave.arr_set[@ _ch - _wave.arr_set_index_ignore]*5
			_wave_y = _value 
		} 
		 
		draw_text(_x_draw,_y_draw+_wave_y,_char)
		if(_monospace == -1) {
			_x_draw += string_width(_char) 
		} else {
			_x_draw += _monospace
		}
	}
	
	draw_set_color(_default_color)
	draw_set_alpha(_default_alpha)
	draw_set_font(_default_font)
	draw_set_halign(_default_halign)
	draw_set_valign(_default_valign)
}