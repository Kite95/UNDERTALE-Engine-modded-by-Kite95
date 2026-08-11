_list_inst=ds_list_create();
_list_cmd=ds_list_create();
_list_mini=ds_list_create();

_super_skip=true;
_super_skip_mode=0;
_super_skip_interval=3;
_super_skip_speed=3;

function Voice_ApplyGroup(){
	Voice_StopLoop();
	_voice_mode=0;
	_voice_mode_interval=6;
	_audio_pitch=1;
	_audio_pitch_random=0;
	_voice_stop=true;
	if(_voice<0)return;
	if(variable_instance_exists(id,"_group_voice_interval")&&is_array(_group_voice_interval)&&_voice<array_length(_group_voice_interval)&&_group_voice_interval[_voice]>0){
		_voice_mode=1;
		_voice_mode_interval=_group_voice_interval[_voice];
	}
	if(variable_instance_exists(id,"_group_voice_pitch")&&is_array(_group_voice_pitch)&&_voice<array_length(_group_voice_pitch)&&_group_voice_pitch[_voice]!=0){
		_audio_pitch=_group_voice_pitch[_voice];
	}
	if(variable_instance_exists(id,"_group_voice_pitch_random")&&is_array(_group_voice_pitch_random)&&_voice<array_length(_group_voice_pitch_random)){
		_audio_pitch_random=_group_voice_pitch_random[_voice];
	}
	if(variable_instance_exists(id,"_group_voice_stop")&&is_array(_group_voice_stop)&&_voice<array_length(_group_voice_stop)){
		if(is_bool(_group_voice_stop[_voice])){
			_voice_stop=_group_voice_stop[_voice];
		}
	}
}

function TriggerCallback(type){
	var map=(type==0) ? _callback_start : _callback_end;
	var key=string(_segment_index);
	if(!variable_struct_exists(map,key))return;
	var list=map[$ key];
	var len=array_length(list);
	for(var i=0;i<len;i+=1){
		if(!is_undefined(list[i])){
			list[i]();
		}
	}
}

function AddFunc(type,index,func){
	var map=(type==0) ? _callback_start : _callback_end;
	var key=string(index);
	if(!variable_struct_exists(map,key)){
		map[$ key]=[];
	}
	var list=map[$ key];
	array_push(list,func);
}

function RemoveFunc(type,index){
	var map=(type==0) ? _callback_start : _callback_end;
	var key=string(index);
	if(variable_struct_exists(map,key)){
		variable_struct_remove(map,key);
	}
}

function Voice_StopLoop(){
	if(variable_instance_exists(id,"_voice_loop_snd")&&_voice_loop_snd!=-1){
		audio_stop_sound(_voice_loop_snd);
		_voice_loop_snd=-1;
	}
	_voice_mode_timer=0;
}

function Voice_PlayOnce(){
	if(_voice<0)return -1;
	var sound=-1;
	if(_voice_single>=0&&_voice_single<array_length_2d(_group_voice,_voice)){
		sound=_group_voice[_voice,_voice_single];
	}else{
		sound=_group_voice[_voice,irandom(array_length_2d(_group_voice,_voice)-1)];
	}
	if(!audio_exists(sound))return -1;
	if(_voice_stop)audio_stop_sound(sound);
	var snd=audio_play_sound(sound,0,false);
	var pitch=_audio_pitch;
	if(_audio_pitch_random!=0){
		pitch=_audio_pitch+random(_audio_pitch_random);
	}
	if(pitch!=1)audio_sound_pitch(snd,pitch);
	return snd;
}

function AlignApply(){
	if(_per_line_align&&_halign==1){
		_align_offset_x=-_measure_w/2;
	}else{
		switch(_halign){
			case 1: _align_offset_x=-_measure_w/2; break;
			case 2: _align_offset_x=-_measure_w; break;
			default: _align_offset_x=0; break;
		}
	}
	switch(_valign){
		case 1: _align_offset_y=-_measure_h/2; break;
		case 2: _align_offset_y=-_measure_h; break;
		default: _align_offset_y=0; break;
	}
	_char_x=(_per_line_align&&_halign==1) ? 0 : _align_offset_x;
	_char_y=_align_offset_y;
}

function Measure(){
	var mtext=argument[0];
	var mfont=(argument_count>1) ? argument[1] : 0;
	var mscale_x=(argument_count>2) ? argument[2] : 1;
	var mscale_y=(argument_count>3) ? argument[3] : 1;
	var mspace_x=(argument_count>4) ? argument[4] : 0;
	var mspace_y=(argument_count>5) ? argument[5] : 0;
	var mx=0;
	var my=0;
	var max_width=0;
	var line_height=0;
	var proc=1;
	var text_len=string_length(mtext);
	var space_y_font=0;

	while(proc<=text_len){
		var ch=string_char_at(mtext,proc);
		if(ch=="{"){
			var cmd_end=proc;
			var brace_depth=1;
			while(cmd_end<text_len&&brace_depth>0){
				cmd_end+=1;
				var c=string_char_at(mtext,cmd_end);
				if(c=="{")brace_depth+=1;
				else if(c=="}")brace_depth-=1;
			}
			var cmd_str=string_copy(mtext,proc+1,cmd_end-proc-1);
			proc=cmd_end+1;

			var cmd_name="";
			var cmd_args="";
			var space_pos=0;
			var in_quote=false;
			var cmd_len=string_length(cmd_str);
			for(var i=1;i<=cmd_len;i+=1){
				var cc=string_char_at(cmd_str,i);
				if(cc=="`"||cc=="\"")in_quote=!in_quote;
				if(!in_quote&&cc==" "&&space_pos==0)space_pos=i;
			}
			if(space_pos>0){
				cmd_name=string_copy(cmd_str,1,space_pos-1);
				cmd_args=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
			}else{
				cmd_name=cmd_str;
			}

			switch(cmd_name){
				case "font":
					if(string_length(cmd_args)>0){
						var val=real(cmd_args);
						if(val>=0&&val<array_height_2d(_group_font))mfont=val;
					}
					break;
				case "scale":
					if(string_length(cmd_args)>0){
						mscale_x=real(cmd_args);
						mscale_y=mscale_x;
					}
					break;
				case "scale_x":
					if(string_length(cmd_args)>0)mscale_x=real(cmd_args);
					break;
				case "scale_y":
					if(string_length(cmd_args)>0)mscale_y=real(cmd_args);
					break;
				case "space_x":
					if(string_length(cmd_args)>0)mspace_x=real(cmd_args);
					break;
				case "space_y":
					if(string_length(cmd_args)>0)mspace_y=real(cmd_args);
					break;
				case "sprite":
					var spr_name="";
					var arg_len=string_length(cmd_args);
					var si=1;
					while(si<=arg_len&&string_char_at(cmd_args,si)==" ")si+=1;
					if(si<=arg_len&&string_char_at(cmd_args,si)=="`"){
						si+=1;
						while(si<=arg_len&&string_char_at(cmd_args,si)!="`"){
							spr_name+=string_char_at(cmd_args,si);
							si+=1;
						}
						si+=1;
					}
					var offx=0;
					var offy=0;
					var num_index=0;
					while(si<=arg_len){
						if(string_char_at(cmd_args,si)==" "){
							si+=1;
							continue;
						}
						var num_str="";
						while(si<=arg_len&&string_char_at(cmd_args,si)!=" "){
							num_str+=string_char_at(cmd_args,si);
							si+=1;
						}
						if(num_str!=""){
							num_index+=1;
							if(num_index==2)offx=real(num_str);
							else if(num_index==3)offy=real(num_str);
						}
					}
					if(spr_name!=""){
						var spr=asset_get_index(spr_name);
						if(sprite_exists(spr)){
							draw_set_font(_group_font[mfont,0]);
							var spr_w=sprite_get_width(spr);
							var spr_h=sprite_get_height(spr);
							var spr_xo=sprite_get_xoffset(spr);
							var spr_yo=sprite_get_yoffset(spr);
							var spr_right=mx+(spr_xo+offx+spr_w)*_group_font_scale_x[mfont,0]*mscale_x;
							mx+=(spr_w+_group_font_space_x[mfont,0]+mspace_x)*_group_font_scale_x[mfont,0]*mscale_x;
							max_width=max(max_width,spr_right);
							line_height=max(line_height,(spr_h-spr_yo+offy)*mscale_y);
						}
					}
					break;
				case "clear":
					draw_set_font(_group_font[mfont,0]);
					space_y_font=_group_font_space_y[mfont];
					var line_height_clear=(string_height(" ")+space_y_font+mspace_y)*_group_font_scale_y[mfont,0]*mscale_y;
					return [max_width,my+max(line_height_clear,line_height)];
			}
		}else if(ch=="\n"){
			draw_set_font(_group_font[mfont,0]);
			space_y_font=_group_font_space_y[mfont];
			var line_height_nl=(string_height(" ")+space_y_font+mspace_y)*_group_font_scale_y[mfont,0]*mscale_y;
			mx=0;
			my+=max(line_height_nl,line_height);
			line_height=0;
			proc+=1;
		}else if(ch=="\\"){
			proc+=1;
			if(proc<=text_len){
				ch=string_char_at(mtext,proc);
				var font_index_esc=(ord(ch)<128) ? 0 : 1;
				draw_set_font(_group_font[mfont,font_index_esc]);
				var next_esc=(proc+1<=text_len) ? string_char_at(mtext,proc+1) : "";
				var chars_esc=(variable_instance_exists(id,"_group_font_chars") ? _group_font_chars[mfont,font_index_esc] : undefined);
				var sp_esc=Typer_CharSpacing(chars_esc,ch,next_esc);
				var scx_esc=_group_font_scale_x[mfont,font_index_esc]*mscale_x;
				mx+=sp_esc[0]*scx_esc;
				mx+=(string_width(ch)+_group_font_space_x[mfont,font_index_esc]+mspace_x+sp_esc[2])*scx_esc;
				mx+=sp_esc[1]*scx_esc;
				max_width=max(max_width,mx);
				draw_set_font(_group_font[mfont,0]);
				space_y_font=_group_font_space_y[mfont];
				line_height=max(line_height,(string_height(" ")+space_y_font+mspace_y)*_group_font_scale_y[mfont,0]*mscale_y);
				proc+=1;
			}
		}else{
			var font_index=(ord(ch)<128) ? 0 : 1;
			draw_set_font(_group_font[mfont,font_index]);
			var next_ch=(proc+1<=text_len) ? string_char_at(mtext,proc+1) : "";
			var chars=(variable_instance_exists(id,"_group_font_chars") ? _group_font_chars[mfont,font_index] : undefined);
			var sp=Typer_CharSpacing(chars,ch,next_ch);
			var scx=_group_font_scale_x[mfont,font_index]*mscale_x;
			mx+=sp[0]*scx;
			mx+=(string_width(ch)+_group_font_space_x[mfont,font_index]+mspace_x+sp[2])*scx;
			mx+=sp[1]*scx;
			max_width=max(max_width,mx);
			draw_set_font(_group_font[mfont,0]);
			space_y_font=_group_font_space_y[mfont];
			line_height=max(line_height,(string_height(" ")+space_y_font+mspace_y)*_group_font_scale_y[mfont,0]*mscale_y);
			proc+=1;
		}
	}

	draw_set_font(_group_font[mfont,0]);
	space_y_font=_group_font_space_y[mfont];
	var line_height_end=(string_height(" ")+space_y_font+mspace_y)*_group_font_scale_y[mfont,0]*mscale_y;
	return [max_width,my+max(line_height_end,line_height)];
}

function ChangeText(){
	var TEXT=argument[0];
	_clearing=true;
	event_user(3);
	_clearing=false;
	event_user(6);
	_callback_start_pend=false;
	text=TEXT;
	Voice_ApplyGroup();
	if(text!=""){
		var m=Measure(text);
		_measure_w=m[0];
		_measure_h=m[1];
		_measured=true;
		AlignApply();
		if(_mini_auto_layout){
			_mini_positions=ScanMinis(text);
			_mini_pos_index=0;
		}
	}
	_segment_index=0;
	_callback_end_done=false;
	TriggerCallback(0);
}

function ScanMinis(text){
	var positions=[];
	var len=string_length(text);
	var i=1;
	var scan_scale_x=_scale_x;
	var scan_mini_right=_mini_right;
	var scan_mini_left=_mini_left;
	var scan_mini_align=_mini_align;
	while(i<=len){
		if(string_char_at(text,i)=="{"){
			if(i+5<=len&&string_copy(text,i+1,5)=="clear"){
				var check=i+6;
				while(check<=len&&string_char_at(text,check)==" ")check+=1;
				if(check<=len&&string_char_at(text,check)=="}"){
					break;
				}
			}
			var cmd_start=i+1;
			var cmd_end=cmd_start;
			var brace_depth=1;
			while(cmd_end<=len&&brace_depth>0){
				if(string_char_at(text,cmd_end)=="{")brace_depth+=1;
				else if(string_char_at(text,cmd_end)=="}")brace_depth-=1;
				if(brace_depth>0)cmd_end+=1;
			}
			var cmd_str=string_copy(text,cmd_start,cmd_end-cmd_start);
			var space_pos=0;
			var in_quote=false;
			var cmd_len=string_length(cmd_str);
			var si=1;
			while(si<=cmd_len){
				var cc=string_char_at(cmd_str,si);
				if(cc=="`"){
					in_quote=!in_quote;
				}
				if(!in_quote&&cc==" "&&space_pos==0){
					space_pos=si;
				}
				si+=1;
			}
			var cmd_name="";
			if(space_pos>0){
				cmd_name=string_copy(cmd_str,1,space_pos-1);
			}else{
				cmd_name=cmd_str;
			}
			if(cmd_name=="scale"||cmd_name=="scale_x"){
				var cmd_args=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
				if(string_length(cmd_args)>0){
					scan_scale_x=real(cmd_args);
				}
			}
			if(cmd_name=="mini_left"){
				var cmd_args_dl=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
				if(string_length(cmd_args_dl)>0){
					scan_mini_left=real(cmd_args_dl);
				}
			}
			if(cmd_name=="mini_right"){
				var cmd_args_dr=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
				if(string_length(cmd_args_dr)>0){
					scan_mini_right=real(cmd_args_dr);
				}
			}
			if(cmd_name=="mini_align"){
				var cmd_args_ma=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
				if(string_length(cmd_args_ma)>0){
					scan_mini_align=real(cmd_args_ma);
				}
			}
			if(cmd_name=="mini"){
				var args_str=string_copy(cmd_str,space_pos+1,cmd_len-space_pos);
				var args=[];
				var current_arg="";
				var in_quote2=false;
				var arg_len=string_length(args_str);
				var ai=1;
				while(ai<=arg_len){
					var ch=string_char_at(args_str,ai);
					if(ch=="`"){
						in_quote2=!in_quote2;
						ai+=1;
						continue;
					}
					if(ch==" "&&!in_quote2){
						if(current_arg!=""){
							array_push(args,current_arg);
							current_arg="";
						}
						ai+=1;
						continue;
					}
					current_arg+=ch;
					ai+=1;
				}
				if(current_arg!=""){
					array_push(args,current_arg);
				}
				if(array_length(args)>=1){
					var mtxt=args[0];
					var mface=(array_length(args)>=2) ? real(args[1]) : -1;
					var mfont=(array_length(args)>=4) ? real(args[3]) : _font;
					if(mfont<0||mfont>=array_height_2d(_group_font))mfont=_font;
					var mox=(array_length(args)>=5) ? real(args[4]) : 0;
					var mscale=scan_scale_x*0.5;
					var mw=0;
					if(mtxt!=""){
						var mm=Measure(mtxt,mfont,mscale,mscale,0,0);
						mw=mm[0];
					}
					var has_face=(mface>=0&&mface<array_length_1d(_group_face));
					var effective_w=mw+(has_face ? 60*mscale : 0)+30*mscale;
					array_push(positions,{mw:mw,ew:effective_w,mox:mox});
				}
			}
			i=cmd_end;
		}
		i+=1;
	}
	var count=array_length(positions);
	if(count==0)return [];
	var left_edge=x+scan_mini_left;
	var right_edge=x+scan_mini_right;
	var half=scan_scale_x*0.5;
	var result=[];
	for(var j=0;j<count;j+=1){
		var mx;
		if(scan_mini_align==0){
			mx=left_edge+positions[j].mox;
			for(var k=j-1;k>=0;k-=1){
				mx+=positions[k].ew;
			}
		}else{
			mx=right_edge+positions[j].mox-positions[j].mw;
			for(var k=j+1;k<count;k+=1){
				mx-=positions[k].ew;
			}
		}
		array_push(result,mx+30*half*(scan_mini_align==1));
	}
	return result;
}

function ChoiceParseBool(_val){
	if(is_bool(_val))return _val;
	if(is_string(_val))return string_lower(_val)=="true";
	if(is_real(_val))return _val!=0;
	return false;
}

function ChoiceHasSlot(_idx){
	if(_idx<0||_idx>=array_length(_choice_reg))return false;
	return _choice_reg[_idx];
}

function ChoiceSoulAtCursor(){
	draw_set_font(_group_font[_font,0]);
	return [
		_char_x-string_width(" ")*_group_font_scale_x[_font,0]*_scale_x,
		_char_y+string_height(" ")/2*_group_font_scale_y[_font,0]*_scale_y
	];
}

function ChoiceRegister(_idx){
	var _pos=ChoiceSoulAtCursor();
	while(array_length(_choice_reg)<=_idx)array_push(_choice_reg,false);
	_choice_x[_idx]=_pos[0];
	_choice_y[_idx]=_pos[1];
	_choice_reg[_idx]=true;
	_choice_count=max(_choice_count,_idx+1);
}

function ChoiceSetCenterFromCursor(){
	var _pos=ChoiceSoulAtCursor();
	_choice_cx=_pos[0];
	_choice_cy=_pos[1];
	_choice_center_manual=true;
}

function ChoiceCalcCenter(){
	if(_choice_center_manual)return;
	var _minx,_miny,_maxx,_maxy,_has=false;
	for(var _i=0;_i<_choice_count;_i++){
		if(!ChoiceHasSlot(_i))continue;
		var _cx=_choice_x[_i];
		var _cy=_choice_y[_i];
		if(!_has){
			_minx=_cx;
			_miny=_cy;
			_maxx=_cx;
			_maxy=_cy;
			_has=true;
		}else{
			_minx=min(_minx,_cx);
			_miny=min(_miny,_cy);
			_maxx=max(_maxx,_cx);
			_maxy=max(_maxy,_cy);
		}
	}
	if(!_has){
		_choice_cx=0;
		_choice_cy=0;
		return;
	}
	_choice_cx=(_minx+_maxx)*0.5;
	_choice_cy=(_miny+_maxy)*0.5;
}

function ChoiceTargetPos(){
	if(_choice_active&&_choice_none&&_choice<0)return [_choice_cx,_choice_cy];
	if(_choice>=0)return [_choice_x[_choice],_choice_y[_choice]];
	return [0,0];
}

function ChoiceSnapVisual(){
	var _t=ChoiceTargetPos();
	_choice_vx=_t[0];
	_choice_vy=_t[1];
}

function ChoiceActivate(){
	ChoiceCalcCenter();
	_choice_active=true;
	_choice=(_choice_none)?-1:0;
	ChoiceSnapVisual();
}

function ChoiceTrySelect(_slot){
	if(!ChoiceHasSlot(_slot))return false;
	if(_choice!=_slot){
		_choice=_slot;
		if(_choice_switch_snd)audio_play_sound(snd_menu_switch,0,false);
	}
	return true;
}

function ChoicePickFirst(_slots){
	for(var _i=0;_i<array_length(_slots);_i++){
		if(ChoiceTrySelect(_slots[_i]))return true;
	}
	return false;
}

function ChoiceStepGrid(){
	if(_choice_none){
		if(Input_IsPressed(INPUT.UP)){
			if(_choice==-1)ChoicePickFirst([0,1]);
			else if(_choice>=2)ChoiceTrySelect(_choice-2);
		}
		if(Input_IsPressed(INPUT.DOWN)){
			if(_choice==-1)ChoicePickFirst([2,3]);
			else if(_choice<2)ChoiceTrySelect(_choice+2);
		}
		if(Input_IsPressed(INPUT.LEFT)){
			if(_choice==-1)ChoicePickFirst([0,2]);
			else if(_choice mod 2==1)ChoiceTrySelect(_choice-1);
		}
		if(Input_IsPressed(INPUT.RIGHT)){
			if(_choice==-1)ChoicePickFirst([1,3]);
			else if(_choice mod 2==0)ChoiceTrySelect(_choice+1);
		}
		return;
	}
	if(Input_IsPressed(INPUT.DOWN)||Input_IsPressed(INPUT.UP)){
		if(_choice>=0&&_choice<2)ChoiceTrySelect(_choice+2);
		else if(_choice>=2)ChoiceTrySelect(_choice-2);
	}
	if(Input_IsPressed(INPUT.LEFT)||Input_IsPressed(INPUT.RIGHT)){
		if(_choice>=0&&_choice mod 2==0)ChoiceTrySelect(_choice+1);
		else if(_choice>=0)ChoiceTrySelect(_choice-1);
	}
}

function ChoiceStepLinear(){
	var _len=max(_choice_count,2);
	var _fwd=(_choice_dir==0)?INPUT.RIGHT:INPUT.DOWN;
	var _back=(_choice_dir==0)?INPUT.LEFT:INPUT.UP;
	if(Input_IsPressed(_fwd)){
		if(_choice_none&&_choice==-1)ChoiceTrySelect(0);
		else ChoiceTrySelect((_choice+1) mod _len);
	}
	if(Input_IsPressed(_back)){
		if(_choice_none&&_choice==-1)ChoiceTrySelect(_len-1);
		else ChoiceTrySelect((_choice-1+_len) mod _len);
	}
}

function ChoiceStep(){
	if(!_choice_active)return;
	if(_choice_dir==3){
		if(Input_IsPressed(INPUT.UP))ChoiceTrySelect(0);
		if(Input_IsPressed(INPUT.LEFT))ChoiceTrySelect(1);
		if(Input_IsPressed(INPUT.RIGHT))ChoiceTrySelect(2);
		if(Input_IsPressed(INPUT.DOWN))ChoiceTrySelect(3);
	}else if(_choice_dir==2){
		ChoiceStepGrid();
	}else if(_choice_dir==0||_choice_dir==1){
		ChoiceStepLinear();
	}
	if(Input_IsPressed(INPUT.CONFIRM)&&_choice>=0){
		if(is_string(_choice_macro)&&_choice_macro!=""){
			variable_struct_remove(_macro,_choice_macro);
			_macro[$ _choice_macro]=_choice;
		}
		Storage_GetTempGeneral().Set(FLAG_TEMP_TEXT_TYPER_CHOICE,_choice);
		_choice_active=false;
		_choice=-1;
		_paused=false;
		if(_choice_confirm_snd)audio_play_sound(snd_menu_confirm,0,false);
	}
	if(_choice_anim){
		var _t=ChoiceTargetPos();
		_choice_vx=lerp(_choice_vx,_t[0],0.6);
		_choice_vy=lerp(_choice_vy,_t[1],0.6);
	}
}

function ChoiceDraw(){
	if(!_choice_active)return;
	var _pos=_choice_anim?[_choice_vx,_choice_vy]:ChoiceTargetPos();
	if(_angle!=0){
		draw_sprite_ext(spr_battle_soul_red,0,x+_pos[0],y+_pos[1],1,1,_angle,c_white,1);
	}else{
		draw_sprite(spr_battle_soul_red,0,x+_pos[0],y+_pos[1]);
	}
}

event_user(6);
Voice_ApplyGroup();
