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
if(instance_exists(_inst_save)){
	instance_destroy(_inst_save);
}
if(instance_exists(_inst_overwrite_return)){
	instance_destroy(_inst_overwrite_return);
}
if(_state!=11){
	if(instance_exists(_inst_return)){
		instance_destroy(_inst_return);
	}
}

var i=0;
repeat(3){
	if(instance_exists(_inst_slot[i])){
		instance_destroy(_inst_slot[i]);
	}
	if(instance_exists(_inst_slot_lv[i])){
		instance_destroy(_inst_slot_lv[i]);
	}
	if(instance_exists(_inst_slot_name[i])){
		instance_destroy(_inst_slot_name[i]);
	}
	if(instance_exists(_inst_slot_time[i])){
		instance_destroy(_inst_slot_time[i]);
	}
	if(instance_exists(_inst_slot_room[i])){
		instance_destroy(_inst_slot_room[i]);
	}
	_inst_slot[i]=noone;
	_inst_slot_lv[i]=noone;
	_inst_slot_name[i]=noone;
	_inst_slot_time[i]=noone;
	_inst_slot_room[i]=noone;
	i+=1;
}

if(instance_exists(_inst_overwrite)){
	instance_destroy(_inst_overwrite);
}
if(instance_exists(_inst_old_lv)){
	instance_destroy(_inst_old_lv);
}
if(instance_exists(_inst_old_name)){
	instance_destroy(_inst_old_name);
}
if(instance_exists(_inst_old_time)){
	instance_destroy(_inst_old_time);
}
if(instance_exists(_inst_old_room)){
	instance_destroy(_inst_old_room);
}
if(instance_exists(_inst_new_lv)){
	instance_destroy(_inst_new_lv);
}
if(instance_exists(_inst_new_name)){
	instance_destroy(_inst_new_name);
}
if(instance_exists(_inst_new_time)){
	instance_destroy(_inst_new_time);
}
if(instance_exists(_inst_new_room)){
	instance_destroy(_inst_new_room);
}

_inst_name=noone;
_inst_lv=noone;
_inst_time=noone;
_inst_room=noone;
_inst_save=noone;
if(_state!=11){
	_inst_return=noone;
}
_inst_overwrite=noone;
_inst_overwrite_return=noone;
_inst_old_lv=noone;
_inst_old_name=noone;
_inst_old_time=noone;
_inst_old_room=noone;
_inst_new_lv=noone;
_inst_new_name=noone;
_inst_new_time=noone;
_inst_new_room=noone;
_time_str="";
_time_prefix="";

var s=Storage_GetInfo();
var z=Storage_GetInfoGeneral();
var bx=108+6;
var by=118+6;
var time=0;
var minute=0;
var second=0;
var peek=-1;
var col="";
var inst=noone;

if(_state==0){
	s.ClearData();
	s.LoadFromFile();
	
	_inst_name=instance_create_depth(bx+26+_info_off_x_0,by+16,0,text_typer);
	_inst_name.text=_prefix+z.Get(FLAG_INFO_NAME,Lang_GetString("ui.save.name.empty"));
	
	_inst_lv=instance_create_depth(bx+180+_info_off_x_1,by+16,0,text_typer);
	_inst_lv.text=_prefix+"LV "+string(z.Get(FLAG_INFO_LV,0));
	
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	_inst_time=instance_create_depth(bx+338+_info_off_x_2,by+16,0,text_typer);
	_inst_time.text=_prefix+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix;
	
	_inst_room=instance_create_depth(bx+26,by+56,0,text_typer);
	_inst_room.text=_prefix+Player_GetRoomName(asset_get_index(z.Get(FLAG_INFO_ROOM,"--")));
	
	_inst_save=instance_create_depth(bx+56+_save_off_x,by+116,0,text_typer);
	_inst_save.text=_prefix+Lang_GetString("ui.save.save","Save");
	
	_inst_return=instance_create_depth(bx+236+_return_off_x,by+116,0,text_typer);
	_inst_return.text=_prefix+Lang_GetString("ui.save.return","Return");
}

if(_state==10||_state==12){
	col=(_state==12 ? "{color_text `yellow`}" : "");
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	
	_inst_lv=instance_create_depth(100,34,0,text_typer);
	_inst_lv.text=_prefix+col+"LV "+string(Player_GetLv());
	
	_inst_name=instance_create_depth(320,34,0,text_typer);
	_inst_name.text=_prefix+col+"{halign 1}"+string(Player_GetName());
	
	_inst_time=instance_create_depth(543,34,0,text_typer);
	_inst_time.text=_prefix+col+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix+col+"{halign 2}";
	
	_inst_room=instance_create_depth(320,66,0,text_typer);
	_inst_room.text=_prefix+col+"{halign 1}"+Player_GetRoomName(room);
	
	i=0;
	repeat(3){
		_slot_peek[i]=-1;
		if(Storage_SlotExists(i)){
			_slot_peek[i]=Storage_PeekSlot(i);
		}
		peek=_slot_peek[i];
		if(_state==12&&i==_slot_choice){
			_inst_slot[i]=instance_create_depth(320,162+i*84,0,text_typer);
			_inst_slot[i].text=_prefix+"{color_text `yellow`}{halign 1}"+Lang_GetString("ui.save.saved","File Saved.");
		}else if(!is_struct(peek)){
			_inst_slot[i]=instance_create_depth(320,162+i*84,0,text_typer);
			_inst_slot[i].text=_prefix+"{halign 1}"+Lang_GetString("ui.save.new","NEW FILE");
		}else{
			minute=floor(peek.time/60);
			second=peek.time%60;
			_inst_slot_lv[i]=instance_create_depth(124,146+i*84,0,text_typer);
			_inst_slot_lv[i].text=_prefix+"LV "+string(peek.lv);
			_inst_slot_name[i]=instance_create_depth(320,146+i*84,0,text_typer);
			_inst_slot_name[i].text=_prefix+"{halign 1}"+string(peek.name);
			_inst_slot_time[i]=instance_create_depth(543,146+i*84,0,text_typer);
			_inst_slot_time[i].text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
			_inst_slot_room[i]=instance_create_depth(320,178+i*84,0,text_typer);
			_inst_slot_room[i].text=_prefix+"{halign 1}"+Player_GetRoomName(asset_get_index(peek.room));
		}
		i+=1;
	}
	
	if(_state==10){
		_inst_return=instance_create_depth(320,396,0,text_typer);
		_inst_return.text=_prefix+"{halign 1}"+Lang_GetString("ui.save.return","Return");
	}
	
	i=0;
	repeat(3){
		col=c_white;
		if(i==_slot_choice){
			col=c_yellow;
		}else if(_state==12){
			col=c_dkgray;
		}
		inst=_inst_slot[i];
		if(instance_exists(inst)){
			inst.override_color_text_enabled=true;
			inst.override_color_text=col;
		}
		inst=_inst_slot_lv[i];
		if(instance_exists(inst)){
			inst.override_color_text_enabled=true;
			inst.override_color_text=col;
		}
		inst=_inst_slot_name[i];
		if(instance_exists(inst)){
			inst.override_color_text_enabled=true;
			inst.override_color_text=col;
		}
		inst=_inst_slot_time[i];
		if(instance_exists(inst)){
			inst.override_color_text_enabled=true;
			inst.override_color_text=col;
		}
		inst=_inst_slot_room[i];
		if(instance_exists(inst)){
			inst.override_color_text_enabled=true;
			inst.override_color_text=col;
		}
		i+=1;
	}
	if(instance_exists(_inst_return)){
		_inst_return.override_color_text_enabled=true;
		if(_state==12){
			_inst_return.override_color_text=c_dkgray;
		}else{
			_inst_return.override_color_text=(_slot_choice==3 ? c_yellow : c_white);
		}
	}
}

if(_state==11){
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	
	_inst_lv=instance_create_depth(100,34,0,text_typer);
	_inst_lv.text=_prefix+"LV "+string(Player_GetLv());
	
	_inst_name=instance_create_depth(320,34,0,text_typer);
	_inst_name.text=_prefix+"{halign 1}"+string(Player_GetName());
	
	_inst_time=instance_create_depth(543,34,0,text_typer);
	_inst_time.text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix+"{halign 2}";
	
	_inst_room=instance_create_depth(320,66,0,text_typer);
	_inst_room.text=_prefix+"{halign 1}"+Player_GetRoomName(room);
	
	peek=_slot_peek[_slot_choice];
	
	_inst_overwrite=instance_create_depth(320,123,0,text_typer);
	_inst_overwrite.text=_prefix+"{halign 1}{define `SLOT` `"+string(_slot_choice+1)+"`}"+Lang_GetString("ui.save.overwrite","Overwrite File {insert SLOT}?");
	
	if(is_struct(peek)){
		_inst_old_lv=instance_create_depth(80,165,0,text_typer);
		_inst_old_lv.text=_prefix+"LV "+string(peek.lv);
		_inst_old_name=instance_create_depth(320,165,0,text_typer);
		_inst_old_name.text=_prefix+"{halign 1}"+string(peek.name);
		minute=floor(peek.time/60);
		second=peek.time%60;
		_inst_old_time=instance_create_depth(557,165,0,text_typer);
		_inst_old_time.text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
		_inst_old_room=instance_create_depth(320,195,0,text_typer);
		_inst_old_room.text=_prefix+"{halign 1}"+Player_GetRoomName(asset_get_index(peek.room));
	}
	
	_inst_new_lv=instance_create_depth(80,237,0,text_typer);
	_inst_new_lv.text=_prefix+"{color_text `yellow`}LV "+string(Player_GetLv());
	
	_inst_new_name=instance_create_depth(320,237,0,text_typer);
	_inst_new_name.text=_prefix+"{color_text `yellow`}{halign 1}"+string(Player_GetName());
	
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	_inst_new_time=instance_create_depth(557,237,0,text_typer);
	_inst_new_time.text=_prefix+"{color_text `yellow`}{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	
	_inst_new_room=instance_create_depth(320,267,0,text_typer);
	_inst_new_room.text=_prefix+"{color_text `yellow`}{halign 1}"+Player_GetRoomName(room);
	
	_inst_save=instance_create_depth(170,316,0,text_typer);
	_inst_save.text=_prefix+Lang_GetString("ui.save.save","Save");
	
	_inst_overwrite_return=instance_create_depth(350,316,0,text_typer);
	_inst_overwrite_return.text=_prefix+Lang_GetString("ui.save.return","Return");
	
	_inst_save.override_color_text_enabled=true;
	_inst_overwrite_return.override_color_text_enabled=true;
	_inst_save.override_color_text=(_overwrite_choice==0 ? c_yellow : c_white);
	_inst_overwrite_return.override_color_text=(_overwrite_choice==1 ? c_yellow : c_white);
}

if(_state==1){
	Storage_Save(_save_target_slot);
	SFX_Play(snd_save,0,false);
	
	_inst_name=instance_create_depth(bx+26+_info_off_x_0,by+16,0,text_typer);
	_inst_name.text=_prefix+"{color_text `yellow`}"+z.Get(FLAG_INFO_NAME,Lang_GetString("ui.save.name.empty"));
	
	_inst_lv=instance_create_depth(bx+180+_info_off_x_1,by+16,0,text_typer);
	_inst_lv.text=_prefix+"{color_text `yellow`}LV "+string(z.Get(FLAG_INFO_LV,0));
	
	time=z.Get(FLAG_INFO_TIME,0);
	minute=floor(time/60);
	second=time%60;
	_inst_time=instance_create_depth(bx+338+_info_off_x_2,by+16,0,text_typer);
	_inst_time.text=_prefix+"{color_text `yellow`}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	
	_inst_room=instance_create_depth(bx+26,by+56,0,text_typer);
	_inst_room.text=_prefix+"{color_text `yellow`}"+Player_GetRoomName(asset_get_index(z.Get(FLAG_INFO_ROOM,"")));
	
	_inst_save=instance_create_depth(bx+56+_save_off_x,by+116,0,text_typer);
	_inst_save.text=_prefix+"{color_text `yellow`}"+Lang_GetString("ui.save.saved","File Saved.");
}
