/*
line break    = [/n]
change color  = [#<hex_code>]
change alpha  = [alpha,<value>]
change scale  = [scale,<value>]
default color = [/c]
default alpha = [/a]
default scale = [/s]
default font  = [/f]

effects
[rainbow][wave][shake]
*/
enum str_data {
	type,
	value,
	x,
	y,
	xoff,
	yoff,
	scl,
	ang,
	col,
	alpha,
	fx,
	fnt,
}

enum str_fx {none, rainbow, wave, shake, wobble, blink, pulse, fade}

enum str_type {char, sprite, sound, surface}

///@func letrator_add_text(font, string, sep, w, color, alpha)
function letrator_add_text(_font, _string, _sep, _w = infinity, _col, _alph) constructor {
	static text_sys_counter = 0;
	text_sys_counter++;
	
	str_size = string_length(_string);
	str_arr = array_create(str_size);
	default_color = _col
	default_alpha = _alph
	default_scale = 1
	default_font  = _font
	
	draw_set_font(default_font)			//roda o init setando a fonte
	
	clean_string = ""	
	tw_index = 0
	
	//fx variables
	
	
	//variables used in the initial loop
	var _type = str_type.char
	var _data = ""
	var _xx = 0
	var _yy = 0
	var _xoff = 0
	var _yoff = 0
	var _scale = default_scale
	var _ang = 0
	var _color = default_color
	var _alpha = default_alpha
	var _fx = 0
	var _fnt = default_font
	
	var _char;
	var _sprite;
	var _sound;
	var _next_chr;
	
	var _chr_scl = _scale
	var _spr_scl = _scale
	var _char_w	= 0
	var _char_h = 0

	for (var i = 0; i < str_size; ++i) {
		//atualiza as variáveis de cada iteracao
		_char		= string_copy(_string, i+1, 1)				//pega a letra no inicio do loop
		_next_chr	= string_copy(_string, i+2, 1)				//caratere afrente do atual	
		_xoff		= 0
		_yoff		= 0
		_char_w		= string_width(_char)*_scale				//pega a largura do caractere atual
		_char_h		= string_height(_char)*_scale				//pega o tamanho do caractere atual
		
		
		//quebra de linha automática. TODO: propper wrap
		if (_xx > _w) {
			_xx = 0
			_yy += _char_h+_sep
			if (_char == " ") {
				_string = string_delete(_string, i+1, 1)
				_char = string_copy(_string, i+1, 1)
				str_size -= 1
				_char_w	= string_width(_char)*_scale
			}
		}
			
		if (_char == "[") {
			if (_next_chr == "[") {
				//show_message("dois [ juntos")
			} else {
				//inicia variáveis do parser
				var _cmd_str = ""
				var _cmd_end = ""
				var _count	 = 0
			
				//forma a string do comando
				while (_cmd_end != "]") {
					_count++
					_cmd_end = string_copy(_string, i+_count, 1)
					_cmd_str += (_cmd_end)				
				}
			
				//parser
				if (string_copy(_cmd_str, 2, 1) == "#") {				//hex
					_color = hex(string_copy(_cmd_str, 3, 6))			
				} else if (string_pos(",", _cmd_str) != 0) {			//keyword, valor
					var _coma_cmd	= ""
					var _coma_chr	= ""
					var _coma_cnt	= 0
					var _coma_val	= ""
					var _coma_pos	= 0
					
					//lê o comando antes da virgula
					while (_coma_chr != ",") {
						_coma_cnt++
						_coma_cmd += _coma_chr
						_coma_chr = string_copy(_cmd_str, _coma_cnt+1, 1)	
						_coma_pos = _coma_cnt
					}
					
					//lê o valor depois da virgula
					_coma_chr	= ""
					while (_coma_chr != "]") {
						_coma_cnt++
						_coma_val += _coma_chr
						_coma_chr = string_copy(_cmd_str, _coma_cnt+1, 1)
					}
					_coma_val = real(_coma_val)
				
					//casos de comando com valor
					switch (_coma_cmd) {
						case "alpha":	_alpha = _coma_val		break;
						case "scale":
							_chr_scl = _coma_val
							_scale = _chr_scl
						break;
					}
				} else {
					//se nao for um comando contendo # e nem virgula, removo os colchetes e aplico o case
					_cmd_str = string_replace_all(_cmd_str, "[", "")
					_cmd_str = string_replace_all(_cmd_str, "]", "")
					
					switch (_cmd_str) {
						//-------------------------|| slash commands ||-------------------------					
						case "/n":
							_xx		= 0
							_yy		+= _char_h+_sep
						break;
						case "/a":
						case "/alpha":	_alpha = default_alpha	break;
						case "/c":
						case "/color":	_color = default_color	break;
						case "/s":
						case "/scale":
							_chr_scl = default_scale
							_scale = _chr_scl
						break;
						case "/f":
						case "/font":	_fnt   = default_font
							if (_fnt != draw_get_font()) {
								draw_set_font(_fnt)	//se a fonte detectada nao for a atual do frame, ele troca pra nova
							}
						break;
						
						//-------------------------|| constant collors ||-------------------------	
						
						case "c_aqua":		_color = c_aqua		break;
						case "c_black":		_color = c_black	break;
						case "c_blue":		_color = c_blue		break;
						case "c_dkgray":	_color = c_dkgray	break;
						case "c_fuchsia":	_color = c_fuchsia	break;
						case "c_gray":		_color = c_gray		break;
						case "c_green":		_color = c_green	break;
						case "c_lime":		_color = c_lime		break;
						case "c_ltgray":	_color = c_ltgray	break;
						case "c_maroon":	_color = c_maroon	break;
						case "c_navy":		_color = c_navy		break;
						case "c_olive":		_color = c_olive	break;
						case "c_orange":	_color = c_orange	break;
						case "c_purple":	_color = c_purple	break;
						case "c_red":		_color = c_red		break;
						case "c_silver":	_color = c_silver	break;
						case "c_teal":		_color = c_teal		break;
						case "c_white":		_color = c_white	break;
						case "c_yellow":	_color = c_yellow	break;
						
						//-------------------------|| set fx ||-------------------------	
						
						case "rainbow": _fx = bitmap_write(_fx, str_fx.rainbow, true)			break;
						case "wave":	_fx = bitmap_write(_fx, str_fx.wave, true)				break;
						case "shake":	_fx = bitmap_write(_fx, str_fx.shake, true)				break;
						case "wobble":	_fx = bitmap_write(_fx, str_fx.wobble, true)			break;
						case "blink":	_fx = bitmap_write(_fx, str_fx.blink, true)				break;
						case "pulse":	_fx = bitmap_write(_fx, str_fx.pulse, true)				break;
						
						//-------------------------|| reset fx ||-------------------------	
						
						case "/clear":	_fx = 0													break;
						
						case "/rainbow": _fx = bitmap_write(_fx, str_fx.rainbow, false)			break;
						case "/wave":	_fx = bitmap_write(_fx, str_fx.wave, false)				break;
						case "/shake":	_fx = bitmap_write(_fx, str_fx.shake, false)			break;
						case "/wobble":	_fx = bitmap_write(_fx, str_fx.wobble, false)			break;
						case "/blink":	_fx = bitmap_write(_fx, str_fx.blink, false)			break;
						case "/pulse":	_fx = bitmap_write(_fx, str_fx.pulse, false)			break;
						
						//-------------------------|| strings nao-específicas ||-------------------------	
						
						default:
							var _cmd_clean_str = string_replace_all(_cmd_str, "/", "")
							var _asset_index = asset_get_index(_cmd_clean_str)
							if (_asset_index > -1) {	//caso seja um asset
								switch (asset_get_type(_cmd_clean_str)) {
									
									case asset_sprite://--------------------------------------------------|| sprite
										//ajust sprite coords
										var _xscl, _yscl;
										_xscl = _char_w*_scale/sprite_get_width(_asset_index)
										_yscl = _char_h*_scale/sprite_get_height(_asset_index)
										_spr_scl = max(_xscl, _yscl)
										
										_type = str_type.sprite								
										_sprite = _asset_index
									break;
									
									case asset_font://--------------------------------------------------|| font
										_fnt = _asset_index									
										if (_fnt != draw_get_font()) {
											draw_set_font(_fnt)	//se a fonte detectada nao for a atual do frame, ele troca pra nova
											_char_h = string_height(_char)*_scale
										}
									break;
								}
							} else {
								show_debug_message("Can't identify <"+_cmd_clean_str+">")
							}							
						break;
					}//sai do case
				}//sai do parser	
				
				//revove o comando da string e retorna a iteracao pro caractede antes do comando
				_string = string_delete(_string, i+1, _count)
				i--
				str_size -= _count
				continue;
			}
		}
		
		switch (_type) {
			case str_type.char:
				_data = _char
				_scale = _chr_scl
			break;
			case str_type.sprite:
				_data = _sprite
				_scale = _spr_scl
				//_xoff = 0
			break;
		}
		
		

		clean_string+=_char	//not used yet
		
		//add the individual values on the array
		str_arr[i][str_data.type]	= _type
		str_arr[i][str_data.value]	= _data
		str_arr[i][str_data.x]		= _xx
		str_arr[i][str_data.y]		= _yy
		str_arr[i][str_data.xoff]	= _xoff
		str_arr[i][str_data.yoff]	= _yoff
		str_arr[i][str_data.scl]	= _scale
		str_arr[i][str_data.ang]	= _ang
		str_arr[i][str_data.col]	= _color
		str_arr[i][str_data.alpha]	= _alpha
		str_arr[i][str_data.fx]		= _fx
		str_arr[i][str_data.fnt]	= _fnt
		
		_type	= str_type.char	
		_xx += _char_w
	//seta o tipo padrao como char	
	}
	
	draw_set_font(-1) //reseta a fonte após as iteracoes
	
	//show_debug_message(str_arr)
	
	static draw = function(_x, _y) {
		for (var i = 0; i < str_size; i++) {		
			#region effects
			var _fx_data = str_arr[i][str_data.fx]

			//wave			
			if (bitmap_read(_fx_data, str_fx.wave)) {
				var _wave_ampl	= 2
				var _wave_freq	= 5
				var _wave_spd	= 0.15
				var _wave		= sin((current_time*(_wave_spd*0.05))+(i*_wave_freq))*_wave_ampl
				str_arr[i][str_data.yoff] = _wave
			}
			
			//rainbow
			if (bitmap_read(_fx_data, str_fx.rainbow)) {
				var _hue_spd	= 3
				var _hue_freq	= 10
				var _sat		= 255*0.7
				var _hue		= (current_time*(_hue_spd*0.05)+(i*_hue_freq)) mod 255
				str_arr[i][str_data.col] = make_color_hsv(_hue, _sat, 255)
			}
			
			//shake
			if (bitmap_read(_fx_data, str_fx.shake)) {
				var _shk_str	= 1.00
				var _shk_x		= random_range(-_shk_str, _shk_str)
				var _shk_y		= random_range(-_shk_str, _shk_str)
				str_arr[i][str_data.xoff] = _shk_x
				str_arr[i][str_data.yoff] = _shk_y
			}
			
			//wobble		
			if (bitmap_read(_fx_data, str_fx.wobble)) {
				var _wobble_ampl= 16
				var _wobble_freq= 0
				var _wobble_spd	= 0.1
				var _wobble		= sin((current_time*(_wobble_spd*0.05))+(i*_wobble_freq))*_wobble_ampl
				str_arr[i][str_data.ang] = _wobble
			}		
			
			#endregion
			
			switch (str_arr[i][str_data.type]) {
				case str_type.char:
					var _cur_font = draw_get_font()
					if (str_arr[i][str_data.fnt] != _cur_font) {
						draw_set_font(str_arr[i][str_data.fnt])
					}
					draw_text_transformed_color(
						_x+str_arr[i][str_data.x]+str_arr[i][str_data.xoff],
						_y+str_arr[i][str_data.y]+str_arr[i][str_data.yoff],
						str_arr[i][str_data.value],
						str_arr[i][str_data.scl],
						str_arr[i][str_data.scl],
						str_arr[i][str_data.ang],
						str_arr[i][str_data.col],
						str_arr[i][str_data.col],
						str_arr[i][str_data.col],
						str_arr[i][str_data.col],
						str_arr[i][str_data.alpha]
					)
				break;
				case str_type.sprite:
					show_debug_message("tentando desenhar sprite")
					draw_sprite_ext(
						str_arr[i][str_data.value],
						0,	//no animations yet :(
						_x+str_arr[i][str_data.x]+str_arr[i][str_data.xoff],
						_y+str_arr[i][str_data.y]+str_arr[i][str_data.yoff],
						str_arr[i][str_data.scl],
						str_arr[i][str_data.scl],
						str_arr[i][str_data.ang],
						str_arr[i][str_data.col],
						str_arr[i][str_data.alpha],
					)
				break;
			}
			draw_rectangle_color(
				_x+str_arr[i][str_data.x],
				_y+str_arr[i][str_data.y],
				_x+str_arr[i][str_data.x]+string_width(str_arr[i][str_data.value])*str_arr[i][str_data.scl]-1,
				_y+str_arr[i][str_data.y]+string_height(str_arr[i][str_data.value])*str_arr[i][str_data.scl],
				c_lime,
				c_lime,
				c_lime,
				c_lime,
				true
			)
		}//end loop
		draw_set_font(-1)
	}
	
	static typewriter = function() {
		
	}
}

//--------------------------------|| complementary functions

function bitmap_write(_map, _index, _bool) {
	var _mask
	var _value = 1<<_index
	
	if (_bool){
		_mask = _map | _value
	} else {
		_mask = _map & ~_value
	}
	return _mask
}

function bitmap_read(_map, _index) {
	return (_map & 1<<_index)>>_index
}

function bitmap_array(_map, _minimum_size = 8) {
	var _len
	if (_map == 0) {
		_len = _minimum_size
	} else {
		_len = floor(log2(_map))+1	
	}	
	var _arr = []
	for (var i = 0; i< _len; i++) {
		_arr[i] = bitmap_read(_map, i)
	}
	return _arr;
}

function hex(string) {
	var result=0;
	
	var ZERO=ord("0");
	var NINE=ord("9");
	var A=ord("A");
	var F=ord("F");

	for (var i=1; i<=string_length(string); i++){
		//pega o valor numerico da letra ou numero
	    var c=ord(string_char_at(string_upper(string), i));
		//move ele 4 bites pra esquerda (multiplica por 16)
		result=result<<4;

		//se o valor ta entre 0 e 9
	    if (c>=ZERO&&c<=NINE){
			//o valor soma com (valor menos código de zero)
	        result=result+(c-ZERO);
		//se o valor ta entre A e F
	    } else if (c>=A&&c<=F){
			//o valor soma com (valor menos código de A e mais 10)
	        result=result+(c-A+10);
	    } 
	}
	//retorna em RGB pq >gamemaker
	return (result>>16 & 0xff) | (result<<16 & 0xff0000) | (result & 0xff00);;
}

