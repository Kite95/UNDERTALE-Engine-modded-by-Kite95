/// Fill missing settings.general keys; returns true if anything was added.
function Settings_FillDefaults(){
	var z=Storage_GetSettingsGeneral();
	var data=z.GetData();
	var dirty=false;

	if(!variable_struct_exists(data,FLAG_SETTINGS_LANGUAGE)){
		z.Set(FLAG_SETTINGS_LANGUAGE,"english");
		dirty=true;
	}
	if(!variable_struct_exists(data,FLAG_SETTINGS_BORDER)){
		z.Set(FLAG_SETTINGS_BORDER,0);
		dirty=true;
	}
	if(!variable_struct_exists(data,FLAG_SETTINGS_MASTER_VOLUME)){
		z.Set(FLAG_SETTINGS_MASTER_VOLUME,100);
		dirty=true;
	}
	if(!variable_struct_exists(data,FLAG_SETTINGS_BGM_VOLUME)){
		z.Set(FLAG_SETTINGS_BGM_VOLUME,100);
		dirty=true;
	}
	if(!variable_struct_exists(data,FLAG_SETTINGS_SOUND_EFFECTS)){
		z.Set(FLAG_SETTINGS_SOUND_EFFECTS,100);
		dirty=true;
	}
	return dirty;
}

/// First-run defaults for settings.json (global, not per save slot).
function Settings_CustomInitialData(){
	var s=Storage_GetSettings();
	if(!s.IsFileExists()){
		Settings_FillDefaults();
		s.SaveToFile();
	}
}
