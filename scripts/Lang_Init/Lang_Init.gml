function Lang_Init() {
	//GMU_Lang v1.7.1

	var WD=working_directory;
	var LAST=string_char_at(WD,string_length(WD));
	if(LAST!="/"&&LAST!="\\"){
		WD+="/";
	}
	global._gmu_included_root=WD;
	global._gmu_lang_path=WD+"locale/";
	global._gmu_lang_list=ds_list_create();
	global._gmu_lang_root=ds_map_create();
	global._gmu_lang_manifest=ds_map_create();
	global._gmu_lang_string=ds_map_create();
	global._gmu_lang_sprite=ds_map_create();
	global._gmu_lang_audio=ds_map_create();
	global._gmu_lang_font=ds_map_create();
	global._gmu_lang_loading=false;
	global._gmu_font_registry={};

	font_add_enable_aa(false);

	var REG_PATH=WD+"font/"+GMU_LANG_FONT_REGISTRY;
	if(file_exists(REG_PATH)){
		var REG_OBJ=json_parse(Lang_LoadFileToString(REG_PATH));
		if(is_struct(REG_OBJ)){
			global._gmu_font_registry=REG_OBJ;
		}
	}
}
