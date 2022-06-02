//------------------------------------------//
//				USEFUL FUNCTIONS			//
//------------------------------------------//


/*
//-------------------------------------------------------|| BITMAP
///@func bitmap_write(map, index, bool)
function bitmap_write(_map, _index, _bool) {
    var _mask
    var _value = 1<<_index
    if (_bool) {
        _mask = _map | _value
    } else {
        _mask = _map & ~_value
    }
    return _mask
}

///@func bitmap_read(map, index)
function bitmap_read(_map, _index) {
    var _bitpos = 1<<_index
    return (_map & _bitpos)>>_index
}

///@func bitmap_array(map, [minimum_size])
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

//-------------------------------------------------------|| JSON SAVE

///@func json_save(data, filename, [encoded])
function json_save(_string, _filename, encoded = false) {
    var _json = json_stringify(_string);    
    if (encoded) {
        var _b64 = base64_encode(_json);
        var _buffer = buffer_create(string_byte_length(_b64)+1, buffer_fixed, 1);
        buffer_write(_buffer, buffer_string, _b64);
    } else {
        var _buffer = buffer_create(string_byte_length(_json)+1, buffer_fixed, 1);
        buffer_write(_buffer, buffer_string, _json);
    }    
    buffer_save(_buffer, _filename);
    buffer_delete(_buffer);
}

///@func json_load(filename, [encoded])
function json_load(_filename, encoded = false) {
    var _buffer = buffer_load(_filename);    
    if (encoded) {
        var _b64 = buffer_read(_buffer, buffer_string);
        var _json = base64_decode(_b64);
    } else {
        var _json = buffer_read(_buffer, buffer_string);
    }    
    var _string = json_parse(_json);
    buffer_delete(_buffer);
    return _string;
}

//-------------------------------------------------------|| TILES

///@func draw_tiles_depthshorted(source_layer, [depth_start], [depth_adjust])
function draw_tiles_depthshorted(source_layer, depth_start = 0, depth_adjust = 0) {    
    var _lay_id        = layer_get_id(source_layer);
    var _tile_id    = layer_tilemap_get_id(_lay_id);
    var _tileset    = tilemap_get_tileset(_tile_id)
    var _tm_width    = tilemap_get_width(_tile_id);
    var _tm_height    = tilemap_get_height(_tile_id);
    var _cell_size    = tilemap_get_tile_height(_tile_id);
    var tm_lay        = [];
    var tm_arr        = [];
    var _y            = depth_adjust;
    var _source        = 0;
    
    for (var i = 0; i < _tm_height; i++) {
        
        tm_lay[i] = layer_create(depth_start + (room_height - (_y)));
        tm_arr[i] = layer_tilemap_create(tm_lay[i], 0, 0, _tileset, _tm_width, _tm_width);
        
        for (var j = 0; j < _tm_width; j++) {
            _source = tilemap_get(_tile_id, j, i);
            tilemap_set(tm_arr[i], _source, j, i);
        }
        _y += _cell_size;
    }
    layer_set_visible(source_layer, false);
}

///@func tile_create_wall(tile_layer, wall_object, [wall_depth])
function tile_create_wall(tile_layer, wall_obj, wall_depth = 0) {
    var _tile_layer = tile_layer
    var _wall_obj    = wall_obj
    var _wall_depth = wall_depth
    var lay_id = layer_get_id(_tile_layer);
    var map_id = layer_tilemap_get_id(lay_id);
    var grid_unit = tilemap_get_tile_width(map_id)
    var has_adjacent = false;
    var strip_count = 0;
    var curr_tile, next_tile, strip_start_xx;
    var xx = 0;
    var yy = 0;

    while (yy < room_height) {
        while (xx < room_width) {
            curr_tile = tilemap_get_at_pixel(map_id, xx, yy);
            next_tile = tilemap_get_at_pixel(map_id, xx + grid_unit, yy);
        
            if (curr_tile != 0 && !next_tile) {
                instance_create_depth(xx, yy, _wall_depth, _wall_obj);
            } else if (curr_tile != 0 && next_tile != 0) {
                has_adjacent = true;
                strip_start_xx = xx;
                strip_count++;
            }
        
            while (has_adjacent) {
                xx += grid_unit;
                strip_count++;
            
                if (xx + grid_unit < room_width) {
                    next_tile = tilemap_get_at_pixel(map_id, xx + grid_unit, yy);
                } else {
                    next_tile = 0
                }
            
                if (!next_tile) {
                    has_adjacent = false;
                    var inst = instance_create_depth(strip_start_xx, yy, _wall_depth, _wall_obj);
                    inst.image_xscale = strip_count;
                    strip_count = 0;
                }
            }
            xx += grid_unit;   
        }
        xx = 0;
        yy += grid_unit;
    }    
}

//-------------------------------------------------------|| UTF8 DICTIONARY

///@func key_dictionary(value)
function key_dictionary(value){
	var text;
	switch (value){
		case vk_add:			text = "+"			;break;    
		case vk_alt:			text = "Alt"        ;break;
		case vk_backspace:		text = "Backspace"  ;break;
		case vk_control:		text = "Ctrl"		;break;
		case vk_decimal:		text = "."			;break;
		case vk_delete:			text = "Delete"		;break;
		case vk_divide:			text = "/"			;break;
		case vk_down:			text = "Down"       ;break;
		case vk_end:			text = "End"		;break;
		case vk_enter:			text = "Enter"      ;break;
		case vk_escape:			text = "Esc"		;break;
		case vk_f1:				text = "F1"			;break;
		case vk_f10:			text = "F10"		;break;
		case vk_f11:			text = "F11"		;break;
		case vk_f12:			text = "F12"		;break;
		case vk_f2:				text = "F2"			;break;
		case vk_f3:				text = "F3"			;break;
		case vk_f4:				text = "F4"			;break;
		case vk_f5:				text = "F5"			;break;
		case vk_f6:				text = "F6"			;break;
		case vk_f7:				text = "F7"			;break;
		case vk_f8:				text = "F8"			;break;
		case vk_f9:				text = "F9"			;break;
		case vk_home:			text = "Home"		;break;
		case vk_insert:			text = "Insert"		;break;
		case vk_lalt:			text = "L Alt"		;break;
		case vk_lcontrol:		text = "L Ctrl"		;break;
		case vk_left:			text = "Left"		;break;
		case vk_lshift:			text = "L Shift"	;break;
		case vk_multiply:		text = "*"			;break;
		case vk_numpad0:		text = "NPD 0"		;break;
		case vk_numpad1:		text = "NPD 1"		;break;
		case vk_numpad2:		text = "NPD 2"		;break;
		case vk_numpad3:		text = "NPD 3"		;break;
		case vk_numpad4:		text = "NPD 4"		;break;
		case vk_numpad5:		text = "NPD 5"		;break;
		case vk_numpad6:		text = "NPD 6"		;break;
		case vk_numpad7:		text = "NPD 7"		;break;
		case vk_numpad8:		text = "NPD 8"		;break;
		case vk_numpad9:		text = "NPD 9"		;break;
		case vk_pagedown:		text = "PagDown"    ;break;
		case vk_pageup:			text = "PagUp"      ;break;
		case vk_pause:			text = "Pause"      ;break;
		case vk_printscreen:	text = "PrntScrn"	;break;
		case vk_ralt:			text = "R Alt"		;break;
		case vk_rcontrol:		text = "R Ctrl"		;break;
		//case vk_return:		text = "Return"		;break;
		case vk_right:			text = "Right"		;break;
		case vk_rshift:			text = "R Shift"	;break;
		case vk_shift:			text = "Shift"		;break;
		case vk_space:			text = "Space"		;break;
		case vk_subtract:		text = "-"			;break;
		case vk_tab:			text = "Tab"		;break;
		case vk_up:				text = "Up"			;break;
        
        default : text = chr(value); break;
    }
    return text;
}

//-------------------------------------------------------|| VECTOR

///@func array_contains(array, value, ...)
function array_contains(_array, _value) {
    var _search_arr;
    for (var i = 0; i < argument_count-1; i++) {
        _search_arr[i] = argument[1+i]
    }

    var _len = array_length(_array);
    var _vals = array_length(_search_arr);
    var _qtt = 0;
    
    for (var i = 0; i<_len; i++) {
        for (var j = 0; j<_vals; j++) {    
            if _array[i] == _search_arr[j] {     
                _qtt++;    
            }
        }
    }
    return _qtt;
}

///@func vec2([x], [y])
function vec2(_x = 0, _y = _x) constructor {
	x = _x
	y = _y
}

///@func vec3([x], [y], [z])
function vec3(_x = 0, _y = _x, _z = _x) constructor {
	x = _x
	y = _y
	z = _z
}

//-------------------------------------------------------|| COLOR

///@func hextorgb(hex_code)
function hextorgb(color) {
    return (color>>16 & 0xff) | (color<<16 & 0xff0000) | (color & 0xff00);
}

///@func stringtohex(string)
function stringtohex(string) {
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
	//caso nao queira a inversao pra BGR, deixa ele retornar só o result
	return (result>>16 & 0xff) | (result<<16 & 0xff0000) | (result & 0xff00);;
}

//-------------------------------------------------------|| LERP ANGLE

///@func lerp_direcion(start, final, speed)
function lerp_direction(start, final, vel) {
    var _max, _da, _result;
    _max = 360;
    _da = (final - start) % _max;
    _result = 2 * _da % _max - _da;

    return start + _result * vel;
}

//-------------------------------------------------------|| FORMATING

///@func fill_blank_number(number, fill_count_int, fill_count_dec)
function fill_blank_number(number, fill_count_int, fill_count_dec)
{
    var formated = string_replace_all(string_format(number, fill_count_int, fill_count_dec), " ", "0")
    return formated
}

//-------------------------------------------------------|| KEYCHECK

///@func keycheck(string_or_vk, type)
function keycheck(_key, _type = 0) {
	var _k = is_string(_key) ? ord(_key) : _key
	switch (_type) {
		case 0: return keyboard_check(_k)
		break;
		case 1: return keyboard_check_pressed(_k)
		break
		case 2: return keyboard_check_released(_k)
		break;
	}
}
