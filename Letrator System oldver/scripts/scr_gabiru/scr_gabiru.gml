/* exemplo de como pintar parte do texto

	[c_purple]ola boa[/] noite [c_orange]bruno[/]


*/
/*
function c_draw_text(_col, _font, _x, _y, _text, _sep, _w){
	var ds_text = ds_list_create();
	var ds_text_collor = ds_list_create();
	var ds_collor = ds_list_create();
	var ds_collor_real = ds_list_create();
	var copy = true;
	var changed_collor = false;
	var change_collor = "";
	var change_collor_list = 0;
	var collor_name = "";
	var line = 0;
	
	for(var t = 1; t < (string_length(_text)+1); t++)
	{
		//var guardando caractere por caractere
		var text_for_list = string_copy(_text, t, 1);
		//se a letra for o [ entao o copy para e a troca de cor inicia
		if text_for_list == "["
		{
			copy = false;
			
			if !changed_collor
			{
				changed_collor = true;
				//a cor mudou e a color agora é 0
				change_collor = change_collor_list
			}
		}
		
		//passa o texto para a lista
		//se o copy nao foi interrompido por [, eu boto a letra na ds do texto
		if copy
		{
			ds_list_add(ds_text, text_for_list);
			ds_list_add(ds_text_collor, change_collor);
			if collor_name != ""
			{
				//se o nome da cor atual nao for vazio, eu boto ele na lista e retorno a vazio
				ds_list_add(ds_collor, collor_name);
				collor_name = "";
			}
			
		}
		//se o copy foi interrompido 
		if !copy
		{
			//e o texto atual é um ]
			if text_for_list == "]"
			{
				//o BBcode acabou e eu retorno o copy e desativo a troca de cor
				copy = true;
				changed_collor = false;
				//???
				change_collor_list += 1;
			}
			//se p texto for a barra
			if text_for_list == "/"
			{
				//limpo a string da cor, subtraio a collor list
				change_collor = "";
				change_collor_list -= 1;
			}
			//se o texto nao é mais [ e nem ]
			if text_for_list != "[" && text_for_list != "]"
			{
				//vou colocando as letras dentro da var nome da cor
				collor_name += string_copy(_text, t, 1);
			}
		}
	}
	
	#region converte as cores em string para cores
	for(var c = 0; c<ds_list_size(ds_collor); c++)
	{
	switch(ds_collor[| c])
	{
	case "c_green":
		ds_list_add(ds_collor_real, c_green);
	break;
	case "c_blue":
		ds_list_add(ds_collor_real, c_blue);
	break;
	case "c_yellow":
		ds_list_add(ds_collor_real, c_yellow);
	break;
	case "c_red":
		ds_list_add(ds_collor_real, c_red);
	break;
	case "c_orange":
		ds_list_add(ds_collor_real, c_orange);
	break;
	case "c_purple":
		ds_list_add(ds_collor_real, c_purple);
	break;
	case "c_gray":
		ds_list_add(ds_collor_real, c_gray);
	break;
	case "c_black":
		ds_list_add(ds_collor_real, c_black);
	break;
	case "c_white":
		ds_list_add(ds_collor_real, c_white);
	break;
	case "c_aqua":
		ds_list_add(ds_collor_real, c_aqua);
	break;
	}	
	}
	#endregion
	
	var _ig = 0;
	var sep_line = false;
	var tam = 0;
	
	var comec_linha = 0;
	for(var t = 0; t < (ds_list_size(ds_text)); t++)
	{
		#region pega a proxima palavra do texto
		var ind_1 = noone;
		var ind_2 = noone;
		if ds_text[| t] == " " 
		{
			ind_1 = t+1;
			for(var f = t+1; f < (ds_list_size(ds_text)); f++)
			{
				if ds_text[| f] == " " && ind_2 == noone
				{
					ind_2 = f;
				}
			} 
		}
		
		if ind_1 != noone
		{
			var prox_palavra = "";
			for(var f = ind_1; f< ind_2; f++)
			{
				prox_palavra += string(ds_text[| f])
			} 
		}
		#endregion
		
		draw_set_font(_font);
		
		#region pega a cor da parte atual do texto
		if ds_text_collor[| t] != ""
		{
			var num = ds_text_collor[| t];
			draw_set_color(ds_collor_real[| num])
		}
		#endregion
		
		var xx, yy;
		xx = (_x + tam) -_ig
		yy =  _y + line*_sep
		//pega o tamanho da proxima letra para separar elas
		if t+1 < ds_list_size(ds_text)
		{
			tam += string_width(ds_text[| t])
		}
		
		if sep_line 
		{
			sep_line = false;
			if ds_text[| t] == " "
			{
				t += 1;
			}
		}
		
		if !sep_line
		{
			draw_text(xx, yy, string(ds_text[| t]));
		}
		
		//ve quando prescisa separar a linha
		var tam_text_atual = "";
		for(var f = comec_linha; f < ind_2; f++)
		{
			tam_text_atual += ds_text[| f];
		}
		
		if string_width(tam_text_atual) > _w
		{
			t = ind_1-1;
			comec_linha = ind_1;
			_ig += point_distance(_x, yy, xx, yy) + string_width(ds_text[| t]); 
			line += 1
			sep_line = true;
		} 
		draw_set_color(_col);
	} 
	draw_set_font(-1);
	
	//show_debug_message(ds_list_size(ds_collor_real));
	
	ds_list_destroy(ds_text);
	ds_list_destroy(ds_text_collor);
	ds_list_destroy(ds_collor);
	ds_list_destroy(ds_collor_real);
}
