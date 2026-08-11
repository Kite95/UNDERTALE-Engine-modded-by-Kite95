function Lang_LoadList() {
	Lang_ClearList();

	var LIST=global._gmu_lang_list;
	var MANIFEST_MAP=global._gmu_lang_manifest;
	var ENTRIES=[];

	var _paths=[];
	var _exe=filename_dir(parameter_string(0));
	if(string_char_at(_exe,string_length(_exe))!="\\"&&string_char_at(_exe,string_length(_exe))!="/"){
		_exe+="/";
	}
	var _wd=working_directory;
	if(string_char_at(_wd,string_length(_wd))!="\\"&&string_char_at(_wd,string_length(_wd))!="/"){
		_wd+="/";
	}
	var _prog=program_directory;
	if(string_char_at(_prog,string_length(_prog))!="\\"&&string_char_at(_prog,string_length(_prog))!="/"){
		_prog+="/";
	}

	var _candidates=[_exe+"locale/",_wd+"locale/",_prog+"locale/"];
	for(var _ci=0;_ci<array_length(_candidates);_ci+=1){
		var _cand=_candidates[_ci];
		var _dup_path=false;
		for(var _pi=0;_pi<array_length(_paths);_pi+=1){
			if(_paths[_pi]==_cand){
				_dup_path=true;
				break;
			}
		}
		if(!_dup_path&&directory_exists(_cand)){
			array_push(_paths,_cand);
		}
	}

	global._gmu_lang_path=array_length(_paths)>0 ? _paths[0] : _exe+"locale/";

	for(var _root=0;_root<array_length(_paths);_root+=1){
		var _base=_paths[_root];
		// Collect names first — do not open files while file_find is active.
		var MANIFEST_FILES=[];
		var FILE=file_find_first(_base+"*.json",0);
		while(FILE!=""){
			array_push(MANIFEST_FILES,FILE);
			FILE=file_find_next();
		}
		file_find_close();

		for(var mi=0;mi<array_length(MANIFEST_FILES);mi+=1){
			var STR=Lang_LoadFileToString(_base+MANIFEST_FILES[mi]);
			if(STR!=""){
				var MANIFEST=json_parse(STR);
				var INFO=is_struct(MANIFEST) ? MANIFEST[$ "info"] : undefined;
				if(is_struct(INFO)){
					var LANG=INFO[$ "ascii_name"];
					var ORD=variable_struct_exists(INFO,"order") ? INFO[$ "order"] : 9999;
					if(is_string(LANG)&&LANG!=""&&directory_exists(_base+LANG)){
						var DUP=false;
						for(var d=0;d<array_length(ENTRIES);d+=1){
							if(ENTRIES[d].ascii_name==LANG){
								DUP=true;
								break;
							}
						}
						if(!DUP){
							array_push(ENTRIES,{
								ascii_name:LANG,
								order:ORD,
								manifest:MANIFEST,
								root:_base
							});
						}
					}
				}
			}
		}
	}

	array_sort(ENTRIES,function(a,b){
		return a.order-b.order;
	});

	for(var i=0;i<array_length(ENTRIES);i+=1){
		var ENTRY=ENTRIES[i];
		ds_list_add(LIST,ENTRY.ascii_name);
		ds_map_add(MANIFEST_MAP,ENTRY.ascii_name,ENTRY.manifest);
		ds_map_add(global._gmu_lang_root,ENTRY.ascii_name,ENTRY.root);
	}

	return !ds_list_empty(LIST);


}
