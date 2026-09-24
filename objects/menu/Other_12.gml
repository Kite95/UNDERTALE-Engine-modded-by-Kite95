///@desc Update Menu 0 Text Color
if(_mode==0){
	_change_inst=_inst_begin;
	_change_color=(_choice==0 ? c_yellow : c_white);
	event_user(1);
	_change_inst=_inst_settings;
	_change_color=(_choice==1 ? c_yellow : c_white);
	event_user(1);
}else if(_mode==1){
	_inst_continue.override_color_text=(_choice==0 ? c_yellow : c_white);
	_inst_reset.override_color_text=(_choice==1 ? c_yellow : c_white);
	_inst_settings.override_color_text=(_choice==2 ? c_yellow : c_white);
}else{
	var i=0;
	var col=c_gray;
	var inst=noone;
	repeat(3){
		col=c_gray;
		if(_file_action==6&&i==_erase_slot){
			col=c_red;
		}else if((_file_action==2||_file_action==3)&&i==_copy_from){
			col=c_yellow;
		}else if(_choice==i){
			col=c_white;
		}
		inst=_inst_slot_name[i];
		if(instance_exists(inst)){
			inst.override_color_text=col;
		}
		inst=_inst_slot_lv[i];
		if(instance_exists(inst)){
			inst.override_color_text=col;
		}
		inst=_inst_slot_time[i];
		if(instance_exists(inst)){
			inst.override_color_text=col;
		}
		inst=_inst_slot_room[i];
		if(instance_exists(inst)){
			inst.override_color_text=col;
		}
		i+=1;
	}
	if(instance_exists(_inst_copy)){
		_inst_copy.override_color_text=(_choice==3 ? c_yellow : c_white);
	}
	if(instance_exists(_inst_erase)){
		_inst_erase.override_color_text=(_choice==4 ? c_yellow : c_white);
	}
	if(instance_exists(_inst_settings)){
		_inst_settings.override_color_text=(_choice==5 ? c_yellow : c_white);
	}
	if(instance_exists(_inst_slot_continue)){
		_inst_slot_continue.override_color_text=(_choice_file==0 ? c_yellow : c_white);
	}
	if(instance_exists(_inst_slot_reset)){
		_inst_slot_reset.override_color_text=(_choice_file==1 ? c_yellow : c_white);
	}
}