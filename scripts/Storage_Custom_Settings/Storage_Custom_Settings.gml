// settings data is globally available and is not bound on save slot.
function Storage_Custom_Settings(storages){
	var s=new Storage(Storage_MakeGetFilePathFunc(false,"settings.json"));
	storages.Register("settings",s);
	
	// general — player preferences (see Settings_CustomInitialData for key notes)
	global._storage_cache_settings_general=new StorageZoneStruct();
	s.Register("general",global._storage_cache_settings_general);
}

function Storage_GetSettings(){
	return Storage_GetManager().Get("settings");
}
function Storage_GetSettingsGeneral(){
	return global._storage_cache_settings_general
}
function Storage_SaveSettings(key,value){
	var s=Storage_GetSettings();
	var z=Storage_GetSettingsGeneral();
    z.Set(key,value);
	s.SaveToFile();
}
function Storage_LoadSettings(){
	var s=Storage_GetSettings();
	s.LoadFromFile();
}