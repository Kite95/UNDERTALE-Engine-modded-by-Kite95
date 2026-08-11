///@arg ascii_name
function Lang_GetManifest() {
	var NAME=Lang_ResolveName(argument[0]);
	if(NAME==""){
		return undefined;
	}

	return ds_map_find_value(global._gmu_lang_manifest,NAME);


}
