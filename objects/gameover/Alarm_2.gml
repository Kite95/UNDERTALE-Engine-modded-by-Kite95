if(instance_exists(fader)){
	fader.color=c_black;
}

var room_return=Storage_GetTempGeneral().Get(FLAG_TEMP_BATTLE_ROOM_RETURN,-1);
if(room_exists(room_return)){
	room_set_persistent(room_return,false);
}

var room_target=room_menu;
var slot=Storage_GetSlot();
if(Storage_SlotExists(slot)){
	Storage_Load(slot);
	var room_name=Storage_GetStaticGeneral().Get(FLAG_STATIC_ROOM,"");
	var room_index=asset_get_index(room_name);
	if(room_exists(room_index)){
		room_target=room_index;
	}
}

Fader_Fade(1,0,15);
room_goto(room_target);
