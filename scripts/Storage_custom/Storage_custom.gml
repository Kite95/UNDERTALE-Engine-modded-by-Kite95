function Storage_Custom(){
	var storages=Storage_GetManager();

	global._save_slot=0;

	Storage_Custom_Static(storages);
	Storage_Custom_Dynamic(storages);
	Storage_Custom_Info(storages);
	Storage_Custom_Settings(storages);
	Storage_Custom_Temp(storages);

	Static_CustomInitialData();
	Plot_CustomInitialData();
	Dynamic_CustomInitialData();
	Info_CustomInitialData();
	Settings_CustomInitialData();
	Temp_CustomInitialData();
}

function Storage_GetSaveSlot(){
	return global._save_slot;
}

function Storage_SetSaveSlot(slot){
	global._save_slot=slot;
}

///@arg useSlots  true = undertale_engine/file{N}/file.json ; false = undertale_engine/file.json
///@arg fileName
function Storage_MakeGetFilePathFunc(useSlots,fileName){
	var closure={
		useSlots:useSlots,
		fileName:fileName
	};
	var func=function(){
		var path=GAME_SAVE_NAME+"/";
		if(useSlots){
			var slot=Storage_GetSaveSlot();
			path+="file"+string(slot)+"/";
		}
		path+=fileName;
		return path;
	};
	return method(closure,func);
}
