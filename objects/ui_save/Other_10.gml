var i=0;
var n=0;
var inst=noone;
repeat(array_length(_insts)){
	if(instance_exists(_insts[i])){
		instance_destroy(_insts[i]);
	}
	i+=1;
}
_insts=[];
_hl[0]=[];
_hl[1]=[];
_hl[2]=[];
_hl[3]=[];
_inst_cur_time=noone;
_inst_ow_time=noone;
_time_str="";
_time_prefix="";

var s=Storage_GetInfo();
var z=Storage_GetInfoGeneral();
var bx=108+6;
var by=118+6;
var time=0;
var minute=0;
var second=0;
var yy=0;
var peek=-1;

if(_state==0){
	s.ClearData();
	s.LoadFromFile();
	
	inst=instance_create_depth(bx+26+_info_off_x_0,by+16,0,text_typer);
	inst.text=_prefix+z.Get(FLAG_INFO_NAME,Lang_GetString("ui.save.name.empty"));
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+180+_info_off_x_1,by+16,0,text_typer);
	inst.text=_prefix+"LV "+string(z.Get(FLAG_INFO_LV,0));
	array_push(_insts,inst);
	
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	inst=instance_create_depth(bx+338+_info_off_x_2,by+16,0,text_typer);
	inst.text=_prefix+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	array_push(_insts,inst);
	_inst_cur_time=inst;
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix;
	
	inst=instance_create_depth(bx+26,by+56,0,text_typer);
	inst.text=_prefix+Player_GetRoomName(asset_get_index(z.Get(FLAG_INFO_ROOM,"--")));
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+56+_save_off_x,by+116,0,text_typer);
	inst.text=_prefix+Lang_GetString("ui.save.save","Save");
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+236+_return_off_x,by+116,0,text_typer);
	inst.text=_prefix+Lang_GetString("ui.save.return","Return");
	array_push(_insts,inst);
}

if(_state==10||_state==12){
	var col=(_state==12 ? "{color_text `yellow`}" : "");
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	
	inst=instance_create_depth(100,34,0,text_typer);
	inst.text=_prefix+col+"LV "+string(Player_GetLv());
	array_push(_insts,inst);
	
	inst=instance_create_depth(320,34,0,text_typer);
	inst.text=_prefix+col+"{halign 1}"+string(Player_GetName());
	array_push(_insts,inst);
	
	inst=instance_create_depth(543,34,0,text_typer);
	inst.text=_prefix+col+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	array_push(_insts,inst);
	_inst_cur_time=inst;
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix+col+"{halign 2}";
	
	inst=instance_create_depth(320,66,0,text_typer);
	inst.text=_prefix+col+"{halign 1}"+Player_GetRoomName(room);
	array_push(_insts,inst);
	
	i=0;
	repeat(3){
		yy=i*84;
		_slot_peek[i]=-1;
		if(Storage_SlotExists(i)){
			_slot_peek[i]=Storage_PeekSlot(i);
		}
		peek=_slot_peek[i];
		if(_state==12&&i==_slot_choice){
			inst=instance_create_depth(320,162+yy,0,text_typer);
			inst.text=_prefix+"{color_text `yellow`}{halign 1}"+Lang_GetString("ui.save.saved","File Saved.");
			array_push(_insts,inst);
		}else if(!is_struct(peek)){
			inst=instance_create_depth(320,162+yy,0,text_typer);
			inst.text=_prefix+"{halign 1}"+Lang_GetString("ui.save.new_file","NEW FILE");
			array_push(_insts,inst);
			array_push(_hl[i],inst);
		}else{
			minute=floor(peek.time/60);
			second=peek.time%60;
			
			inst=instance_create_depth(124,146+yy,0,text_typer);
			inst.text=_prefix+"LV "+string(peek.lv);
			array_push(_insts,inst);
			array_push(_hl[i],inst);
			
			inst=instance_create_depth(320,146+yy,0,text_typer);
			inst.text=_prefix+"{halign 1}"+string(peek.name);
			array_push(_insts,inst);
			array_push(_hl[i],inst);
			
			inst=instance_create_depth(543,146+yy,0,text_typer);
			inst.text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
			array_push(_insts,inst);
			array_push(_hl[i],inst);
			
			inst=instance_create_depth(320,178+yy,0,text_typer);
			inst.text=_prefix+"{halign 1}"+Player_GetRoomName(asset_get_index(peek.room));
			array_push(_insts,inst);
			array_push(_hl[i],inst);
		}
		i+=1;
	}
	
	if(_state==10){
		inst=instance_create_depth(320,396,0,text_typer);
		inst.text=_prefix+"{halign 1}"+Lang_GetString("ui.save.return","Return");
		array_push(_insts,inst);
		array_push(_hl[3],inst);
		
		i=0;
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
	}else{
		i=0;
		repeat(array_length(_hl)){
			n=0;
			repeat(array_length(_hl[i])){
				inst=_hl[i][n];
				if(instance_exists(inst)){
					inst.override_color_text_enabled=true;
					inst.override_color_text=c_dkgray;
				}
				n+=1;
			}
			i+=1;
		}
	}
}

if(_state==11){
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	
	inst=instance_create_depth(100,34,0,text_typer);
	inst.text=_prefix+"LV "+string(Player_GetLv());
	array_push(_insts,inst);
	
	inst=instance_create_depth(320,34,0,text_typer);
	inst.text=_prefix+"{halign 1}"+string(Player_GetName());
	array_push(_insts,inst);
	
	inst=instance_create_depth(543,34,0,text_typer);
	inst.text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	array_push(_insts,inst);
	_inst_cur_time=inst;
	_time_str=string(minute)+":"+(second<10 ? "0" : "")+string(second);
	_time_prefix=_prefix+"{halign 2}";
	
	inst=instance_create_depth(320,66,0,text_typer);
	inst.text=_prefix+"{halign 1}"+Player_GetRoomName(room);
	array_push(_insts,inst);
	
	peek=_slot_peek[_slot_choice];
	
	inst=instance_create_depth(320,123,0,text_typer);
	inst.text=_prefix+"{halign 1}{define `SLOT` `"+string(_slot_choice+1)+"`}"+Lang_GetString("ui.save.overwrite_query","Overwrite File {insert SLOT}?");
	array_push(_insts,inst);
	
	if(is_struct(peek)){
		inst=instance_create_depth(80,165,0,text_typer);
		inst.text=_prefix+"LV "+string(peek.lv);
		array_push(_insts,inst);
		
		inst=instance_create_depth(320,165,0,text_typer);
		inst.text=_prefix+"{halign 1}"+string(peek.name);
		array_push(_insts,inst);
		
		minute=floor(peek.time/60);
		second=peek.time%60;
		inst=instance_create_depth(557,165,0,text_typer);
		inst.text=_prefix+"{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
		array_push(_insts,inst);
		
		inst=instance_create_depth(320,195,0,text_typer);
		inst.text=_prefix+"{halign 1}"+Player_GetRoomName(asset_get_index(peek.room));
		array_push(_insts,inst);
	}
	
	inst=instance_create_depth(80,237,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}LV "+string(Player_GetLv());
	array_push(_insts,inst);
	
	inst=instance_create_depth(320,237,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}{halign 1}"+string(Player_GetName());
	array_push(_insts,inst);
	
	time=Storage_GetStaticGeneral().Get(FLAG_STATIC_TIME,0);
	minute=floor(time/60);
	second=time%60;
	inst=instance_create_depth(557,237,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}{halign 2}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	array_push(_insts,inst);
	_inst_ow_time=inst;
	
	inst=instance_create_depth(320,267,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}{halign 1}"+Player_GetRoomName(room);
	array_push(_insts,inst);
	
	inst=instance_create_depth(170,316,0,text_typer);
	inst.text=_prefix+Lang_GetString("ui.save.save","Save");
	array_push(_insts,inst);
	array_push(_hl[0],inst);
	
	inst=instance_create_depth(350,316,0,text_typer);
	inst.text=_prefix+Lang_GetString("ui.save.return","Return");
	array_push(_insts,inst);
	array_push(_hl[1],inst);
	
	inst=instance_create_depth(320,396,0,text_typer);
	inst.text=_prefix+"{halign 1}"+Lang_GetString("ui.save.return","Return");
	array_push(_insts,inst);
	
	i=0;
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

if(_state==1){
	Storage_Save(_save_target_slot);
	audio_play_sound(snd_save,0,false);
	
	inst=instance_create_depth(bx+26+_info_off_x_0,by+16,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}"+z.Get(FLAG_INFO_NAME,Lang_GetString("ui.save.name.empty"));
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+180+_info_off_x_1,by+16,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}LV "+string(z.Get(FLAG_INFO_LV,0));
	array_push(_insts,inst);
	
	time=z.Get(FLAG_INFO_TIME,0);
	minute=floor(time/60);
	second=time%60;
	inst=instance_create_depth(bx+338+_info_off_x_2,by+16,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}"+string(minute)+":"+(second<10 ? "0" : "")+string(second);
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+26,by+56,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}"+Player_GetRoomName(asset_get_index(z.Get(FLAG_INFO_ROOM,"")));
	array_push(_insts,inst);
	
	inst=instance_create_depth(bx+56+_save_off_x,by+116,0,text_typer);
	inst.text=_prefix+"{color_text `yellow`}"+Lang_GetString("ui.save.saved","File Saved.");
	array_push(_insts,inst);
}
