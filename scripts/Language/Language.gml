function Language(){
	var LANG=Storage_GetSettingsGeneral().Get(FLAG_SETTINGS_LANGUAGE,"english");
	if(is_undefined(LANG)||!is_string(LANG)||!Lang_IsExists(LANG)){
		return "english";
	}
	return LANG;
}
