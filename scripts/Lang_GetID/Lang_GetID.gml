///@arg ascii_name
function Lang_GetID() {
	var NAME=Lang_ResolveName(argument[0]);
	if(NAME==""){
		return -1;
	}

	return ds_list_find_index(global._gmu_lang_list,NAME);


}
