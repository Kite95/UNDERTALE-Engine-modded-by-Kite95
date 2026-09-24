if(!_active){
	exit;
}

display_set_gui_size(_gui_w,_gui_h);
display_set_gui_maximize(_gui_scale,_gui_scale,0,0);

if(_use_stick){
	draw_sprite_ext(spr_mobile_joystick,0,_stick_x,_stick_y,_scale,_scale,0,c_white,_alpha);
	draw_sprite_ext(spr_mobile_joystick,1,_stick_x+_stick_dx,_stick_y+_stick_dy,_scale,_scale,0,c_white,_alpha);
}else{
	var i=0;
	repeat(4){
		draw_sprite_ext(_dpad_spr[i],_dpad_held[i]?1:0,_dpad_x[i],_dpad_y[i],_scale,_scale,0,c_white,_alpha);
		i+=1;
	}
}

var i=0;
repeat(array_length(_btn_input)){
	draw_sprite_ext(_btn_spr[i],_btn_held[i]?1:0,_btn_x[i],_btn_y[i],_scale,_scale,0,c_white,_alpha);
	i+=1;
}
