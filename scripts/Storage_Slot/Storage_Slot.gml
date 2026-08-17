function Storage_GetSaveMode(){
	return GAME_SAVE_DEFAULT;
}

function Storage_GetSlotCount(){
	return Storage_GetSaveMode()==SAVE_MODE.TRIPLE ? 3 : 1;
}

function Storage_GetSlot(){
	return Storage_GetSaveSlot();
}

function Storage_SetSlot(slot){
	if(slot<0||slot>=Storage_GetSlotCount()){
		show_debug_message("Storage_SetSlot: invalid slot "+string(slot));
		return false;
	}
	Storage_SetSaveSlot(slot);
	return true;
}

function Storage_GetSlotFilePath(slot,fileName){
	if(Storage_GetSlotCount()==1){
		slot=0;
	}
	return GAME_SAVE_NAME+"/file"+string(slot)+"/"+fileName;
}

function Storage_SlotExists(slot){
	return file_exists(Storage_GetSlotFilePath(slot,"info.json"));
}

function Storage_PeekSlot(slot){
	if(!Storage_SlotExists(slot)){
		return undefined;
	}
	var json=File_ReadAllText(Storage_GetSlotFilePath(slot,"info.json"));
	if(is_undefined(json)){
		return undefined;
	}
	var obj;
	try{
		obj=json_parse(json);
	}catch(e){
		return undefined;
	}
	if(!is_struct(obj)||!variable_struct_exists(obj,"general")){
		return undefined;
	}
	var gen=obj[$"general"];
	var name=gen[$FLAG_INFO_NAME];
	var lv=gen[$FLAG_INFO_LV];
	var time=gen[$FLAG_INFO_TIME];
	var roomName=gen[$FLAG_INFO_ROOM];
	if(is_undefined(name)) name=Lang_GetString("ui.save.name.empty");
	if(is_undefined(lv)) lv=0;
	if(is_undefined(time)) time=0;
	if(is_undefined(roomName)) roomName="";
	return{
		name:name,
		lv:lv,
		time:time,
		room:roomName,
	};
}

function Storage_Save(slot){
	if(Storage_GetSlotCount()==1){
		slot=0;
	}
	Storage_SetSlot(slot);
	Storage_SaveGame();
}

function Storage_Load(slot){
	if(Storage_GetSlotCount()==1){
		slot=0;
	}
	Storage_SetSlot(slot);
	Storage_LoadGame();
}

/// Title menu slot select (hook for future menu UI).
function Storage_MenuSlot(slot){
	Storage_SetSlot(slot);
}

/// Title menu slot summaries (hook for future menu UI).
function Storage_MenuGetSlotSummaries(){
	var out=[];
	var count=Storage_GetSlotCount();
	for(var i=0;i<count;i++){
		out[i]=Storage_PeekSlot(i);
	}
	return out;
}
