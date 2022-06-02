//
//Outline shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_line_direc[8];
uniform float u_pixel_w;
uniform float u_pixel_h;
uniform float u_line_alpha;
uniform vec3 u_line_col;

bool potential_line;
vec4 side_chk;
vec4 corn_chk;

void main()
{
	//Atribui o tamanho do pixel nos vetores
	vec2 x_thick;
	x_thick.x = u_pixel_w;
	vec2 y_thick;
	y_thick.y = u_pixel_h;

	vec2 UV = v_vTexcoord;
	vec4 tcol = texture2D(gm_BaseTexture, UV);
	float alpha = tcol.a;
	
	//Checa o alpha dos 8 pixels adjacentes se o pixel atual for vazio
	if (alpha == 0.0)
	{
		//Sides
		potential_line = true;
		side_chk.x = u_line_direc[3] * texture2D(gm_BaseTexture, UV + x_thick).a;
		side_chk.y = u_line_direc[4] * texture2D(gm_BaseTexture, UV - x_thick).a;
		side_chk.z = u_line_direc[1] * texture2D(gm_BaseTexture, UV + y_thick).a;
		side_chk.w = u_line_direc[6] * texture2D(gm_BaseTexture, UV - y_thick).a;
		//Corners
		corn_chk.x = u_line_direc[5] * texture2D(gm_BaseTexture, UV + vec2(x_thick.x, -y_thick.y)).a;
		corn_chk.y = u_line_direc[0] * texture2D(gm_BaseTexture, UV + vec2(x_thick.x, +y_thick.y)).a;
		corn_chk.z = u_line_direc[7] * texture2D(gm_BaseTexture, UV - vec2(x_thick.x, +y_thick.y)).a;
		corn_chk.w = u_line_direc[2] * texture2D(gm_BaseTexture, UV - vec2(x_thick.x, -y_thick.y)).a;
	}
	
	//Calcula qual foi o maior alpha encontrado
	//O min do GLSL só aceita dois valores entao teve q virar um placar de eliminatória
	vec2 test_1;
	test_1.x = max(side_chk.x, side_chk.y);
	test_1.y = max(side_chk.z, side_chk.w);
	
	vec2 test_2;
	test_2.x = max(corn_chk.x, corn_chk.y);
	test_2.y = max(corn_chk.z, corn_chk.w);
	
	vec2 test_3;
	test_3.x = max(test_1.x, test_1.y);
	test_3.y = max(test_2.x, test_2.y);
	
	float near_alpha = max(test_3.x, test_3.y);
	
	vec4 final_col = texture2D(gm_BaseTexture, v_vTexcoord);
	
	//Colore a outline
	if (potential_line == true && near_alpha > 0.0) {
		final_col.rgb = u_line_col;
		final_col.a = (u_line_alpha == 69420.0 ? v_vColour.a : u_line_alpha);
	}
	
	gl_FragColor = (potential_line ? final_col : v_vColour * final_col);
}