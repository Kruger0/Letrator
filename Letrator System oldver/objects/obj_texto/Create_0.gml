show_debug_overlay(true)

var _str4 = @"[wave][scale,.4]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n][rainbow]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n][shake]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n][/clear]
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA[/n]"

var _str1 = @"
Texto [wave]animado!!![/n][/wave]
[#ff0000]Cores [#0090ff]muito[#40ff40] doidas [/n]
[/c][rainbow]Arround the world [/rainbow] [/n]
[alpha,0.3][wave]Alfa reduzido [/wave][/n]
[#ffff00][/a][scale,0.5]pequeno [scale,1.5]GRAMDE [/c][/s][/n]
[/n]
sprite[spr_star]sprite [/n]
[shake][#ff5a00]pessima ideia[/shake][/n]
[wobble][#00ffff]pra la e pra ca [/c][/n][/wobble]
[/rainbow][/c]ae parou"

var _str2 = @"
Texto [*rainbow(5)] animado!!! 
Cores muito doidas 
[*wave(5)]Arround the world[*cw()] 
[*cr()]Alfa reduzido 
pequeno GRAMDE 
spritesprite 
pessima ideia 
pra la e pra ca 
ae parou"

var _str3 = @"
TESTE DE ESPACO [/n][#00ffff]Teste de espaco [/c][/n]
[fnt_03][wave]Teste de fonte[/n]
[spr_star]
[fnt_02][rainbow]123456789 [/n]
[/f][shake][/rainbow][#ff0000]ola criancada [/n][/c]
[/clear]Tudo limpo :)[/n]
Wingdings!! [fnt_04][/n][#5aff5a]
ABCDEFGHIJKLMN[/n]
OPQRSTUVWXYZ [/n]
[/clear][/f][wobble][#ff5a00][fnt_05]Let's Groove
"
global.debug = false

var _str5 = "[fnt_02][spr_coin] RATINHOO!![/n][scale,.4]RATINHOO!![/n][scale,.5]RATINHOO!![/n][scale,.6]RATINHOOOOO[scale,.4]OOOOO[scale,.8]OO[scale,.6]OOOO!![/n][scale,.7][rainbow][fnt_05]RATINHOO!![/n][scale,.8]RATINHOO!![/n][scale,.4]RATINHOO!![/n][scale,.8][fnt_01][/rainbow][#ff4444]RATINHOO!![/n][scale,.7]"
var _str6 = "[scale, .6]Lorem Ipsum is simply dummy text of the printing and typesetting industry."

var _str7 = "[scale,0.4]Lorem Ipsum is simply dummy text 123456789123456789123456789123456789 of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
text[0] = new letrator_add_text(fnt_01, _str7, 0, 230, c_white, 1)

//show_message(real("c_red"))