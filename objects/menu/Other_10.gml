///@desc Menu Switch
if(_menu==0){
	var s=Storage_GetInfo();
	_mode=s.IsFileExists()?1:0;
	if(_mode==0){
		_inst_instruction=instance_create_depth(170,40,0,text_typer);
		_inst_instruction.text=_prefix+Lang_GetString("menu.instruction");
		_inst_begin=instance_create_depth(170,344,0,text_typer);
		_inst_begin.text=_prefix+Lang_GetString("menu.begin");
		_inst_settings=instance_create_depth(170+Lang_GetLayout("menu.settings_x",0),384,0,text_typer);
		_inst_settings.text=_prefix+Lang_GetString("menu.settings");
		with(text_typer){
			event_user(15);
		}
		event_user(2);
	}else{
		s.ClearData();
		s.LoadFromFile();
		var z=Storage_GetInfoGeneral();
		_inst_name=instance_create_depth(140+Lang_GetLayout("menu.info_text_x",0,0),124,0,text_typer);
		_inst_name.text=_prefix+z.Get(FLAG_INFO_NAME,Lang_GetString("ui.save.name.empty"));
		_inst_lv=instance_create_depth(308+Lang_GetLayout("menu.info_text_x",0,1),124,0,text_typer);
		_inst_lv.text=_prefix+"LV "+string(z.Get(FLAG_INFO_LV,0));
		_inst_time=instance_create_depth(452+Lang_GetLayout("menu.info_text_x",0,2),124,0,text_typer);
		var time=z.Get(FLAG_INFO_TIME,0);
		var minute=floor(time/60);
		var second=time%60;
		_inst_time.text=_prefix+string(minute)+":"+(second<10 ? "0" : "")+string(second);
		_inst_room=instance_create_depth(140,160,0,text_typer);
		var roomIndex=asset_get_index(z.Get(FLAG_INFO_ROOM,""));
		_inst_room.text=_prefix+Player_GetRoomName(roomIndex);
		_inst_continue=instance_create_depth(170+Lang_GetLayout("menu.continue_x",0),210,0,text_typer);
		_inst_continue.text=_prefix+Lang_GetString("menu.continue");
		_inst_continue.override_color_text_enabled=true;
		_inst_reset=instance_create_depth(390+Lang_GetLayout("menu.reset_x",0),210,0,text_typer);
		_inst_reset.text=_prefix+Lang_GetString("menu.reset");
		_inst_reset.override_color_text_enabled=true;
		_inst_settings=instance_create_depth(264+Lang_GetLayout("menu.settings_x",0),250,0,text_typer);
		_inst_settings.text=_prefix+Lang_GetString("menu.settings");
		_inst_settings.override_color_text_enabled=true;
		event_user(2);
		
	}
}else{
	if(instance_exists(_inst_instruction)){
		instance_destroy(_inst_instruction);
	}
	if(instance_exists(_inst_begin)){
		instance_destroy(_inst_begin);
	}
	if(instance_exists(_inst_settings)){
		instance_destroy(_inst_settings);
	}
	if(instance_exists(_inst_name)){
		instance_destroy(_inst_name);
	}
	if(instance_exists(_inst_lv)){
		instance_destroy(_inst_lv);
	}
	if(instance_exists(_inst_time)){
		instance_destroy(_inst_time);
	}
	if(instance_exists(_inst_room)){
		instance_destroy(_inst_room);
	}
	if(instance_exists(_inst_continue)){
		instance_destroy(_inst_continue);
	}
	if(instance_exists(_inst_reset)){
		instance_destroy(_inst_reset);
	}
}

if(_menu==1){
	_inst_naming_title=instance_create_depth(180,60,0,text_typer);
	_inst_naming_title.text=_prefix+Lang_GetString("menu.naming.title");
	_inst_naming_letters=instance_create_depth(120,152,0,text_typer);
	_inst_naming_letters.text=_prefix+"{font 0}{effect 0}{space_x 24}{space_y -2}ABCDEFG\nHIJKLMN\nOPQRSTU\nVWXYZ{space_y -7}\n\n{space_y -2}abcdefg\nhijklmn\nopqrstu\nvwxyz";
	var _bottom_y=400+Lang_GetLayout("menu.bottom_y",0);
	_inst_naming_quit=instance_create_depth(120,_bottom_y,0,text_typer);
	_inst_naming_quit.text=_prefix+Lang_GetString("menu.naming.quit");
	_inst_naming_backspace=instance_create_depth(240,_bottom_y,0,text_typer);
	_inst_naming_backspace.text=_prefix+Lang_GetString("menu.naming.backspace");
	_inst_naming_done=instance_create_depth(440,_bottom_y,0,text_typer);
	_inst_naming_done.text=_prefix+Lang_GetString("menu.naming.done");
	with(text_typer){
		event_user(15);
	}
	event_user(3);
}else{
	if(instance_exists(_inst_naming_title)){
		instance_destroy(_inst_naming_title);
	}
	if(instance_exists(_inst_naming_letters)){
		instance_destroy(_inst_naming_letters);
	}
	if(instance_exists(_inst_naming_quit)){
		instance_destroy(_inst_naming_quit);
	}
	if(instance_exists(_inst_naming_backspace)){
		instance_destroy(_inst_naming_backspace);
	}
	if(instance_exists(_inst_naming_done)){
		instance_destroy(_inst_naming_done);
	}
}

if(_menu==2){
	_inst_confirm_title=instance_create_depth(180,60,0,text_typer);
	_inst_confirm_title.text=_prefix+_confirm_title;
	var _bottom_y=400+Lang_GetLayout("menu.bottom_y",0);
	_inst_confirm_no=instance_create_depth(146,_bottom_y,0,text_typer);
	_inst_confirm_no.text=_prefix+Lang_GetString("menu.no");
	_inst_confirm_yes=instance_create_depth(460,_bottom_y,0,text_typer);
	_inst_confirm_yes.text=_prefix+Lang_GetString("menu.yes");
	_confirm_name_x=280;
	_confirm_name_y=110;
	_confirm_name_scale=2;
	Anim_Destroy(id,"_confirm_name_x");
	Anim_Destroy(id,"_confirm_name_y");
	Anim_Destroy(id,"_confirm_name_scale");
	Anim_Create(id,"_confirm_name_x",0,0,280,-80,135);
	Anim_Create(id,"_confirm_name_y",0,0,110,120,135);
	Anim_Create(id,"_confirm_name_scale",0,0,2,5,135);
	_choice_confirm=0;
	with(text_typer){
		event_user(15);
	}
	event_user(5);
}else{
	if(instance_exists(_inst_confirm_title)){
		instance_destroy(_inst_confirm_title);
	}
	if(instance_exists(_inst_confirm_no)){
		instance_destroy(_inst_confirm_no);
	}
	if(instance_exists(_inst_confirm_yes)){
		instance_destroy(_inst_confirm_yes);
	}
}

if(_menu==3){
	BGM_Stop(0);
	fader.color=c_white;
	Fader_Fade(-1,1,160);
	audio_play_sound(snd_cymbal,0,false);
	alarm[0]=175;
}