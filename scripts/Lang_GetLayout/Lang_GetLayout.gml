///@arg path
///@arg default*
///@arg index*
function Lang_GetLayout() {
	var PATH=argument[0];
	var DEF=0;
	if(argument_count>=2){
		DEF=argument[1];
	}

	var MAN=Lang_GetManifest(Language());
	if(!is_struct(MAN)){
		return DEF;
	}

	var LAY=MAN[$ "layout"];
	if(!is_struct(LAY)){
		return DEF;
	}

	var PARTS=string_split(PATH,".");
	var CUR=LAY;
	for(var i=0;i<array_length(PARTS);i+=1){
		var KEY=PARTS[i];
		if(!is_struct(CUR)||!variable_struct_exists(CUR,KEY)){
			return DEF;
		}
		CUR=CUR[$ KEY];
	}

	if(argument_count>=3&&is_array(CUR)){
		var IDX=argument[2];
		if(IDX>=0&&IDX<array_length(CUR)){
			var V=CUR[IDX];
			return is_real(V)?V:DEF;
		}
		return DEF;
	}

	return is_real(CUR)?CUR:DEF;

}
