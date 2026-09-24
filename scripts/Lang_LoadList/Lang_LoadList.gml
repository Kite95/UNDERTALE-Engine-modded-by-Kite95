function Lang_LoadList() {
	Lang_ClearList();

	var LIST=global._gmu_lang_list;
	var MANIFEST_MAP=global._gmu_lang_manifest;
	var ENTRIES=[];
	var LOCALE=global._gmu_lang_path;

	var OFFICIAL=["english.json","schinese.json"];
	for(var oi=0;oi<array_length(OFFICIAL);oi+=1){
		var STR=Lang_LoadFileToString(LOCALE+OFFICIAL[oi]);
		if(STR==""){
			continue;
		}
		var MANIFEST=json_parse(STR);
		var INFO=is_struct(MANIFEST) ? MANIFEST[$ "info"] : undefined;
		if(!is_struct(INFO)){
			continue;
		}
		var LANG=INFO[$ "ascii_name"];
		if(!is_string(LANG)||LANG==""){
			continue;
		}
		array_push(ENTRIES,{
			ascii_name:LANG,
			order:variable_struct_exists(INFO,"order") ? INFO[$ "order"] : 9999,
			manifest:MANIFEST,
			root:LOCALE
		});
	}

	if(!Game_IsMobile()){
		var _paths=[];
		var _exe=filename_dir(parameter_string(0));
		if(string_char_at(_exe,string_length(_exe))!="\\"&&string_char_at(_exe,string_length(_exe))!="/"){
			_exe+="/";
		}
		var _prog=program_directory;
		if(string_char_at(_prog,string_length(_prog))!="\\"&&string_char_at(_prog,string_length(_prog))!="/"){
			_prog+="/";
		}
		var _candidates=[_exe+"locale/",LOCALE,_prog+"locale/"];
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
		if(array_length(_paths)>0){
			global._gmu_lang_path=_paths[0];
		}

		for(var _root=0;_root<array_length(_paths);_root+=1){
			var _base=_paths[_root];
			var MANIFEST_FILES=[];
			var FILE=file_find_first(_base+"*.json",0);
			while(FILE!=""){
				array_push(MANIFEST_FILES,FILE);
				FILE=file_find_next();
			}
			file_find_close();

			for(var mi=0;mi<array_length(MANIFEST_FILES);mi+=1){
				STR=Lang_LoadFileToString(_base+MANIFEST_FILES[mi]);
				if(STR==""){
					continue;
				}
				MANIFEST=json_parse(STR);
				INFO=is_struct(MANIFEST) ? MANIFEST[$ "info"] : undefined;
				if(!is_struct(INFO)){
					continue;
				}
				LANG=INFO[$ "ascii_name"];
				if(!is_string(LANG)||LANG==""||!directory_exists(_base+LANG)){
					continue;
				}
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
						order:variable_struct_exists(INFO,"order") ? INFO[$ "order"] : 9999,
						manifest:MANIFEST,
						root:_base
					});
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
