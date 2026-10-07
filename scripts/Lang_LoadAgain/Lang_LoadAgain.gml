function Lang_LoadAgain() {
	if(global._gmu_lang_loading){
		return false;
	}
	global._gmu_lang_loading=true;

	Lang_ClearSprite();
	Lang_ClearAudio();
	Lang_ClearFont();
	ds_map_clear(global._gmu_lang_string);
	Lang_LoadLanguage(Language());

	global._gmu_lang_loading=false;
	if(variable_global_exists("_shop")&&is_struct(global._shop)){
		Shop_Custom();
	}
	if(variable_global_exists("_encounter")&&ds_exists(global._encounter,ds_type_map)){
		Encounter_Custom();
	}
	return true;
}
