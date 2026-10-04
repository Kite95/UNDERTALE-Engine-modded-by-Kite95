if(instance_exists(fader)){
	fader.color=c_black;
}

var ret=Storage_GetTempGeneral().Get(FLAG_TEMP_BATTLE_ROOM_RETURN,-1);
if(is_real(ret)&&room_exists(ret)){
	room_set_persistent(ret,false);
}

var slot=Storage_GetSlot();
if(Storage_SlotExists(slot)){
	Storage_Load(slot);
	var roomName=Storage_GetStaticGeneral().Get(FLAG_STATIC_ROOM,"");
	var roomIndex=asset_get_index(roomName);
	if(room_exists(roomIndex)){
		Fader_Fade(1,0,15);
		room_goto(roomIndex);
		exit;
	}
}

Fader_Fade(1,0,15);
room_goto(room_menu);
