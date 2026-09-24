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

function Storage_CopySlot(from,to){
	if(from==to||from<0||to<0){
		return false;
	}
	if(!Storage_SlotExists(from)){
		return false;
	}
	var dest_dir=GAME_SAVE_NAME+"/file"+string(to);
	if(!directory_exists(dest_dir)){
		directory_create(dest_dir);
	}
	var names=["info.json","static.json","dynamic.json"];
	var i=0;
	repeat(3){
		var src=Storage_GetSlotFilePath(from,names[i]);
		var dst=Storage_GetSlotFilePath(to,names[i]);
		if(file_exists(dst)){
			file_delete(dst);
		}
		if(file_exists(src)){
			file_copy(src,dst);
		}
		i+=1;
	}
	return true;
}

function Storage_EraseSlot(slot){
	var names=["info.json","static.json","dynamic.json"];
	var i=0;
	repeat(3){
		var path=Storage_GetSlotFilePath(slot,names[i]);
		if(file_exists(path)){
			file_delete(path);
		}
		i+=1;
	}
	return true;
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
