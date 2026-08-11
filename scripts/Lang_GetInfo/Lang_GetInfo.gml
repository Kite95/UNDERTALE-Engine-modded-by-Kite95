///@arg ascii_name
///@arg string_name
///@arg default*
function Lang_GetInfo() {
	var KEY=argument[1];
	var DEF="";
	if(argument_count>=3){
		DEF=argument[2];
	}

	if(!Lang_IsExists(argument[0])){
		return DEF;
	}

	var MANIFEST=Lang_GetManifest(argument[0]);
	if(!is_struct(MANIFEST)){
		return DEF;
	}

	var INFO=MANIFEST[$ "info"];
	if(!is_struct(INFO)||!variable_struct_exists(INFO,KEY)){
		return DEF;
	}

	var VALUE=INFO[$ KEY];
	if(is_string(VALUE)){
		return VALUE;
	}
	if(is_real(VALUE)){
		return string(VALUE);
	}

	return DEF;


}
