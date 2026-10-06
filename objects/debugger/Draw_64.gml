draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(font_crypt_of_tomorrow);
draw_set_color(c_white);
draw_set_alpha(0.3);
draw_text_transformed(578,466,string(GAME_VERSION),2,2,0);
draw_set_alpha(1);

if(!GAME_DEBUG){
	exit;
}

if(!_armed&&_tip==""){
	exit;
}

draw_set_font(Lang_GetFont("determination_sans",font_mars_needs_cunnilingus));
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var label="";
var hold_need=_hold;
var draw_bar=false;

if(_armed){
	label="TAB";
	var key_n=array_length(_chord_keys);
	for(var i=0;i<key_n;i+=1){
		label+="+"+_chord_keys[i].label;
	}
	if(key_n==1&&variable_struct_exists(_commands,_cur_key)){
		var cmd=_commands[$ _cur_key];
		label+="\n"+cmd.name;
		if(_cur_key!="h"&&_cur_key!="5"&&_cur_key!="3"&&variable_struct_exists(cmd,"tip")&&is_method(cmd.tip)){
			label+="\n"+cmd.tip();
		}
		if(variable_struct_exists(cmd,"hold")){
			hold_need=cmd.hold;
		}
		draw_bar=_charge>0;
	}
}else{
	label=_tip;
}

if(hold_need<=0){
	hold_need=0.01;
}

var scale=1;
var tw=string_width(label)*scale;
var th=string_height(label)*scale;
var cx=display_get_gui_width()/2;
var xx=floor(cx-tw/2);
var yy=4;
var bar_h=0;
if(draw_bar){
	bar_h=5;
}

var alpha=1;
if(!_armed&&alarm[0]<=_tip_fade){
	alpha=clamp(alarm[0]/_tip_fade,0,1);
}

draw_set_color(c_black);
draw_set_alpha(0.5*alpha);
draw_rectangle(xx,yy,xx+tw,yy+th+bar_h,false);
draw_set_alpha(alpha);

draw_set_color(_armed?c_white:c_yellow);
draw_text_transformed(floor(cx),yy,label,scale,scale,0);

if(draw_bar){
	var bar_y=yy+th+1;
	var ratio=clamp(_charge/hold_need,0,1);
	draw_set_color(c_white);
	draw_rectangle(xx,bar_y,xx+max(1,tw*ratio),bar_y+4,false);
}

draw_set_halign(fa_left);
draw_set_color(c_white);
draw_set_alpha(1);
