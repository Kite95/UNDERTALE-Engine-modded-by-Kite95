if(_state==-1){
	if(!instance_exists(ui_dialog)){
		_state=0;
		event_user(0);
	}
}else if(_state==0){
	if(Input_IsPressed(INPUT.LEFT)){
		if(_choice==1){
			_choice=0;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.RIGHT)){
		if(_choice==0){
			_choice=1;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.CONFIRM)){
		if(_choice==0){
			if(Storage_GetSaveMode()==SAVE_MODE.TRIPLE){
				_state=10;
				_slot_choice=0;
				_buffer=1;
				event_user(0);
			}else{
				_save_target_slot=0;
				_state=1;
				event_user(0);
			}
		}else{
			instance_destroy();
		}
	}else if(Input_IsPressed(INPUT.CANCEL)){
		instance_destroy();
	}
}else if(_state==10){
	if(_buffer>0){
		_buffer-=1;
	}else if(Input_IsPressed(INPUT.UP)){
		if(_slot_choice>0){
			_slot_choice-=1;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.DOWN)){
		if(_slot_choice<3){
			_slot_choice+=1;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.CONFIRM)){
		if(_slot_choice<3){
			if(Storage_SlotExists(_slot_choice)&&_slot_choice!=Storage_GetSlot()){
				_overwrite_choice=0;
				_state=11;
				_buffer=1;
				event_user(0);
			}else{
				_save_target_slot=_slot_choice;
				Storage_Save(_save_target_slot);
				audio_play_sound(snd_save,0,false);
				_state=12;
				_buffer=1;
				event_user(0);
			}
		}else{
			_state=0;
			_buffer=1;
			event_user(0);
		}
	}else if(Input_IsPressed(INPUT.CANCEL)){
		_state=0;
		_buffer=1;
		event_user(0);
	}
	
	if(Input_IsPressed(INPUT.UP)||Input_IsPressed(INPUT.DOWN)){
		var i=0;
		var n=0;
		var inst=noone;
		repeat(array_length(_hl)){
			n=0;
			repeat(array_length(_hl[i])){
				inst=_hl[i][n];
				if(instance_exists(inst)){
					inst.override_color_text_enabled=true;
					inst.override_color_text=(i==_slot_choice ? c_yellow : c_white);
				}
				n+=1;
			}
			i+=1;
		}
	}
}else if(_state==11){
	if(_buffer>0){
		_buffer-=1;
	}else if(Input_IsPressed(INPUT.LEFT)){
		if(_overwrite_choice>0){
			_overwrite_choice=0;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.RIGHT)){
		if(_overwrite_choice<1){
			_overwrite_choice=1;
			audio_play_sound(snd_menu_switch,0,false);
		}
	}else if(Input_IsPressed(INPUT.CONFIRM)){
		if(_overwrite_choice==0){
			_save_target_slot=_slot_choice;
			Storage_Save(_save_target_slot);
			audio_play_sound(snd_save,0,false);
			_state=12;
			_buffer=1;
			event_user(0);
		}else{
			_state=10;
			_buffer=1;
			event_user(0);
		}
	}else if(Input_IsPressed(INPUT.CANCEL)){
		_state=10;
		_buffer=1;
		event_user(0);
	}
	
	if(Input_IsPressed(INPUT.LEFT)||Input_IsPressed(INPUT.RIGHT)){
		var i=0;
		var n=0;
		var inst=noone;
		repeat(array_length(_hl)){
			n=0;
			repeat(array_length(_hl[i])){
				inst=_hl[i][n];
				if(instance_exists(inst)){
					inst.override_color_text_enabled=true;
					inst.override_color_text=(i==_overwrite_choice ? c_yellow : c_white);
				}
				n+=1;
			}
			i+=1;
		}
	}
}else if(_state==12){
	if(_buffer>0){
		_buffer-=1;
	}else if(Input_IsPressed(INPUT.CONFIRM)||Input_IsPressed(INPUT.CANCEL)){
		instance_destroy();
	}
}else if(_state==1){
	if(Input_IsPressed(INPUT.CONFIRM)||Input_IsPressed(INPUT.CANCEL)){
		instance_destroy();
	}
}

if(_state==0||_state==10||_state==11||_state==12){
	var time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	var minute=floor(time/60);
	var second=time%60;
	var str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	if(str!=_time_str){
		_time_str=str;
		if(instance_exists(_inst_cur_time)){
			_inst_cur_time.ChangeText(_time_prefix+str);
		}
		if(instance_exists(_inst_ow_time)){
			_inst_ow_time.ChangeText(_prefix+"{color_text `yellow`}{halign 2}"+str);
		}
	}
}
