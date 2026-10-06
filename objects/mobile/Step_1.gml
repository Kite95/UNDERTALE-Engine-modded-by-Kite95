if(!_active){
	exit;
}

var SW=(window_get_fullscreen()?display_get_width():window_get_width());
var SH=(window_get_fullscreen()?display_get_height():window_get_height());
if(os_type==os_android||os_type==os_ios){
	SW=display_get_width();
	SH=display_get_height();
}
var CANVAS_W=640;
var CANVAS_H=480;
var INSET_X=0;
var INSET_Y=0;
if(instance_exists(border)&&Border_IsEnabled()){
	CANVAS_W=960;
	CANVAS_H=540;
	INSET_X=160;
	INSET_Y=30;
}
_gui_scale=min(SW/CANVAS_W,SH/CANVAS_H);
if(_gui_scale<=0){
	_gui_scale=1;
}
_gui_w=round(SW/_gui_scale);
_gui_h=round(SH/_gui_scale);
_game_x=(_gui_w-CANVAS_W)*0.5+INSET_X;
_game_y=(_gui_h-CANVAS_H)*0.5+INSET_Y;
display_set_gui_size(_gui_w,_gui_h);
display_set_gui_maximize(_gui_scale,_gui_scale,0,0);

_stick_radius=sprite_get_width(spr_mobile_joystick)*_scale*0.5;
_stick_grab_r=_stick_radius+_stick_grab;
var DPAD_H=sprite_get_height(spr_mobile_upkey)*_scale;
var DPAD_W=sprite_get_width(spr_mobile_leftkey)*_scale;
var LEFT_R=_use_stick?_stick_radius:(DPAD_W+_dpad_gap_x+(sprite_get_width(spr_mobile_rightkey)-sprite_get_xoffset(spr_mobile_rightkey))*_scale);
_stick_x=max(LEFT_R+_margin,_game_x-LEFT_R-_margin)+_off_stick_x;
_stick_y=_game_y+_off_stick_y;
_dpad_x[0]=_stick_x;
_dpad_y[0]=_stick_y;
_dpad_x[1]=_stick_x;
_dpad_y[1]=_stick_y+DPAD_H+_dpad_gap;
_dpad_x[2]=_stick_x-DPAD_W-_dpad_gap_x;
_dpad_y[2]=_stick_y+(DPAD_H+_dpad_gap)*0.5;
_dpad_x[3]=_stick_x+DPAD_W+_dpad_gap_x;
_dpad_y[3]=_stick_y+(DPAD_H+_dpad_gap)*0.5;

var BTN_W=sprite_get_width(spr_mobile_zkey)*_scale;
var STEP_Y=_btn_step*_scale;
var BTN_Y=_game_y+_off_btn_y;
var GAP=(_btn_layout==2)?_btn_gap:0;
var Z0=_game_x+640+_margin+sprite_get_xoffset(spr_mobile_zkey)*_scale+_off_btn_x;
var C_RIGHT=Z0+(BTN_W+GAP)*2+(sprite_get_width(spr_mobile_ckey)-sprite_get_xoffset(spr_mobile_ckey))*_scale;
if(C_RIGHT>_gui_w-_margin){
	Z0-=C_RIGHT-(_gui_w-_margin);
}
if(_btn_layout==0){
	_btn_x[0]=Z0;
	_btn_y[0]=BTN_Y+STEP_Y;
	_btn_x[1]=Z0+BTN_W;
	_btn_y[1]=BTN_Y;
	_btn_x[2]=Z0+BTN_W*2;
	_btn_y[2]=BTN_Y-STEP_Y;
}else if(_btn_layout==1){
	_btn_x[0]=Z0;
	_btn_y[0]=BTN_Y-STEP_Y;
	_btn_x[1]=Z0+BTN_W;
	_btn_y[1]=BTN_Y;
	_btn_x[2]=Z0+BTN_W*2;
	_btn_y[2]=BTN_Y+STEP_Y;
}else{
	_btn_x[0]=Z0;
	_btn_y[0]=BTN_Y;
	_btn_x[1]=Z0+BTN_W+GAP;
	_btn_y[1]=BTN_Y;
	_btn_x[2]=Z0+(BTN_W+GAP)*2;
	_btn_y[2]=BTN_Y;
}

if(_use_stick){
	if(_stick_device<0){
		var d=0;
		repeat(8){
			if(device_mouse_check_button_pressed(d,mb_left)){
				var tx=device_mouse_x_to_gui(d);
				var ty=device_mouse_y_to_gui(d);
				var jdx=tx-_stick_x;
				var jdy=ty-_stick_y;
				if(jdx*jdx+jdy*jdy<=_stick_grab_r*_stick_grab_r){
					_stick_device=d;
					break;
				}
			}
			d+=1;
		}
	}
	if(_stick_device>=0){
		if(device_mouse_check_button(_stick_device,mb_left)){
			_stick_dx=device_mouse_x_to_gui(_stick_device)-_stick_x;
			_stick_dy=device_mouse_y_to_gui(_stick_device)-_stick_y;
			var len=point_distance(0,0,_stick_dx,_stick_dy);
			if(len>_stick_radius&&len>0){
				_stick_dx=_stick_dx/len*_stick_radius;
				_stick_dy=_stick_dy/len*_stick_radius;
			}
		}else{
			_stick_device=-1;
			_stick_dx=0;
			_stick_dy=0;
		}
	}else{
		_stick_dx=0;
		_stick_dy=0;
	}
}else{
	_stick_device=-1;
	_stick_dx=0;
	_stick_dy=0;
}

var dpad_now=array_create(4,false);
if(_use_stick){
	if(_stick_device>=0){
		if(abs(_stick_dy)>_stick_dead){
			if(_stick_dy<0){
				dpad_now[0]=true;
			}else{
				dpad_now[1]=true;
			}
		}
		if(abs(_stick_dx)>_stick_dead){
			if(_stick_dx<0){
				dpad_now[2]=true;
			}else{
				dpad_now[3]=true;
			}
		}
	}
}else{
	var d=0;
	repeat(8){
		if(device_mouse_check_button(d,mb_left)){
			var tx=device_mouse_x_to_gui(d);
			var ty=device_mouse_y_to_gui(d);
			var i=0;
			repeat(4){
				var spr=_dpad_spr[i];
				var kw=sprite_get_width(spr)*_scale;
				var kh=sprite_get_height(spr)*_scale;
				var left=_dpad_x[i]-sprite_get_xoffset(spr)*_scale-_hit_pad;
				var top=_dpad_y[i]-sprite_get_yoffset(spr)*_scale-_hit_pad;
				if(tx>=left&&tx<=left+kw+_hit_pad*2&&ty>=top&&ty<=top+kh+_hit_pad*2){
					dpad_now[i]=true;
				}
				i+=1;
			}
		}
		d+=1;
	}
}

var btn_n=array_length(_btn_input);
var btn_now=array_create(btn_n,false);
var d=0;
repeat(8){
	if(d!=_stick_device&&device_mouse_check_button(d,mb_left)){
		var tx=device_mouse_x_to_gui(d);
		var ty=device_mouse_y_to_gui(d);
		var i=0;
		repeat(btn_n){
			var spr=_btn_spr[i];
			var kw=sprite_get_width(spr)*_scale;
			var kh=sprite_get_height(spr)*_scale;
			var left=_btn_x[i]-sprite_get_xoffset(spr)*_scale-_hit_pad;
			var top=_btn_y[i]-sprite_get_yoffset(spr)*_scale-_hit_pad;
			if(tx>=left&&tx<=left+kw+_hit_pad*2&&ty>=top&&ty<=top+kh+_hit_pad*2){
				btn_now[i]=true;
			}
			i+=1;
		}
	}
	d+=1;
}

var i=0;
repeat(4){
	if(dpad_now[i]){
		if(_dpad_held[i]){
			Input_SetOverride(_dpad_input[i],INPUT_STATE.HELD);
		}else{
			Input_SetOverride(_dpad_input[i],INPUT_STATE.PRESSED);
		}
	}else if(_dpad_held[i]){
		Input_SetOverride(_dpad_input[i],INPUT_STATE.RELEASED);
	}else{
		Input_RemoveOverride(_dpad_input[i]);
	}
	_dpad_held[i]=dpad_now[i];
	i+=1;
}

i=0;
repeat(btn_n){
	if(btn_now[i]){
		if(_btn_held[i]){
			Input_SetOverride(_btn_input[i],INPUT_STATE.HELD);
		}else{
			Input_SetOverride(_btn_input[i],INPUT_STATE.PRESSED);
		}
	}else if(_btn_held[i]){
		Input_SetOverride(_btn_input[i],INPUT_STATE.RELEASED);
	}else{
		Input_RemoveOverride(_btn_input[i]);
	}
	_btn_held[i]=btn_now[i];
	i+=1;
}
