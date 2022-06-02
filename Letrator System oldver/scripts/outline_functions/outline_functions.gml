#macro OUTLINE_START shader_set(shd_outline)
#macro OUTLINE_END shader_reset()

#macro OL_T		 [0, 1, 0, 0, 0, 0, 0, 0]
#macro OL_L		 [0, 0, 0, 1, 0, 0, 0, 0]
#macro OL_B		 [0, 0, 0, 0, 0, 0, 1, 0]
#macro OL_R		 [0, 0, 0, 0, 1, 0, 0, 0]
#macro OL_TL	 [1, 0, 0, 0, 0, 0, 0, 0]
#macro OL_TR	 [0, 0, 1, 0, 0, 0, 0, 0]
#macro OL_BL	 [0, 0, 0, 0, 0, 1, 0, 0]
#macro OL_BR	 [0, 0, 0, 0, 0, 0, 0, 1]
#macro OL_SIDE	 [0, 1, 0, 1, 1, 0, 1, 0]
#macro OL_CORNER [1, 0, 1, 0, 0, 1, 0, 1]
#macro OL_ALL	 [1, 1, 1, 1, 1, 1, 1, 1]
#macro OL_OFF	 [0, 0, 0, 0, 0, 0, 0, 0]


//----------------------INITIALIZE----------------------//



/// @func	outline_init()
/// @desc	Inicia as variaveis de uniform no objeto
function outline_init() {
	u_pixel_w		= shader_get_uniform(shd_outline, "u_pixel_w");
	u_pixel_h		= shader_get_uniform(shd_outline, "u_pixel_h");
	u_line_col		= shader_get_uniform(shd_outline, "u_line_col");
	u_line_direc	= shader_get_uniform(shd_outline, "u_line_direc");
	u_line_alpha	= shader_get_uniform(shd_outline, "u_line_alpha");
}



//----------------------TEXT----------------------//



/// @func	outline_set_text(thickness, directions)
/// @desc	Configura o shader pra receber um texto
function outline_set_text(_thickness, _directions) {
	var _font = draw_get_font();
	var _texture = font_get_texture(_font);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, [0, 0, 0]);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, 69420);	//foi necessário.
}


/// @func	outline_set_text_color(thickness, directions, color, alpha)
/// @desc	Configura o shader pra receber um texto
function outline_set_text_color(_thickness, _directions, _color, _alpha) {
	var _font = draw_get_font();
	var _texture = font_get_texture(_font);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);
	var _col = [
		colour_get_red(_color)/255,
		colour_get_green(_color)/255,
		colour_get_blue(_color)/255,
	];

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, _col);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, _alpha);
}



//----------------------SPRITE----------------------//



/// @func	outline_set_sprite(sprite, subimg, thickness, directions)
/// @desc	Configura o shader pra receber uma sprite
function outline_set_sprite(_sprite, _subimg, _thickness, _directions) {
	var _texture = sprite_get_texture(_sprite, _subimg);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, [0, 0, 0]);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, 69420);
	return _sprite;
}


/// @func	outline_set_sprite_color(sprite, subimg, thickness, directions, color, alpha)
/// @desc	Configura o shader pra receber uma sprite
function outline_set_sprite_color(_sprite, _subimg, _thickness, _directions, _color, _alpha) {
	var _texture = sprite_get_texture(_sprite, _subimg);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);
	var _col = [
		colour_get_red(_color)/255,
		colour_get_green(_color)/255,
		colour_get_blue(_color)/255,
	];

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, _col);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, _alpha);
	return _sprite;
}



//----------------------SURFACE----------------------//



/// @func	outline_set_surface(surface, thickness, directions)
/// @desc	Configura o shader pra receber uma surface
function outline_set_surface(_surface, _thickness, _directions) {
	var _texture = surface_get_texture(_surface);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, [0, 0, 0]);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, 69420);
	return _surface;
}


/// @func	outline_set_surface_color(surface, thickness, directions, color, alpha)
/// @desc	Configura o shader pra receber uma surface
function outline_set_surface_color(_surface, _thickness, _directions, _color, _alpha) {
	var _texture = surface_get_texture(_surface);
	var _w = texture_get_texel_width(_texture);
	var _h = texture_get_texel_height(_texture);
	var _col = [
		colour_get_red(_color)/255,
		colour_get_green(_color)/255,
		colour_get_blue(_color)/255,
	];

	shader_set_uniform_f(u_pixel_w, _w*_thickness);
	shader_set_uniform_f(u_pixel_h, _h*_thickness);
	shader_set_uniform_f_array(u_line_col, _col);
	shader_set_uniform_f_array(u_line_direc, _directions);
	shader_set_uniform_f(u_line_alpha, _alpha);
	return _surface;
}

