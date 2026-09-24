///@arg ascii_name
function Lang_LoadLanguage() {
	var LANG=Lang_ResolveName(argument[0]);
	if(LANG==""){
		return false;
	}

	var MANIFEST=Lang_GetManifest(LANG);
	if(!is_struct(MANIFEST)){
		return false;
	}

	var BASE=GMU_LANG_PATH_BASE+LANG+"/";
	var _root=ds_map_find_value(global._gmu_lang_root,LANG);
	if(!is_undefined(_root)){
		BASE=_root+LANG+"/";
	}
	var OK=false;

	var MAP=global._gmu_lang_string;
	var STRING_FILES=[];
	var LISTED=MANIFEST[$ "strings"];
	if(is_array(LISTED)){
		for(var li=0;li<array_length(LISTED);li+=1){
			array_push(STRING_FILES,LISTED[li]);
		}
	}else if(!Game_IsMobile()){
		var STRING_DIR=BASE+"string/";
		if(directory_exists(STRING_DIR)){
			var FILE=file_find_first(STRING_DIR+"*.json",0);
			while(FILE!=""){
				array_push(STRING_FILES,"string/"+FILE);
				FILE=file_find_next();
			}
			file_find_close();
		}
	}

	for(var si=0;si<array_length(STRING_FILES);si+=1){
		var PATH=BASE+STRING_FILES[si];
		if(file_exists(PATH)){
			var STR=Lang_LoadFileToString(PATH);
			var obj=json_parse(STR);
			if(is_struct(obj)){
				var names=variable_struct_get_names(obj);
				for(var k=0;k<array_length(names);k+=1){
					var skey=names[k];
					var innerLine=obj[$ skey];
					if(is_string(innerLine)){
						ds_map_set(MAP,skey,innerLine);
					}
				}
				OK=true;
			}
		}
	}

	var SPRITES=MANIFEST[$ "sprites"];
	if(is_array(SPRITES)){
		for(var i=0;i<array_length(SPRITES);i+=1){
			var ENTRY=SPRITES[i];
			if(!is_struct(ENTRY)){
				continue;
			}

			var key=variable_struct_exists(ENTRY,"key") ? ENTRY[$ "key"] : "";
			var src=variable_struct_exists(ENTRY,"source") ? ENTRY[$ "source"] : "";
			var img_num=variable_struct_exists(ENTRY,"image_number") ? ENTRY[$ "image_number"] : 1;
			var remove_back=variable_struct_exists(ENTRY,"remove_background") ? ENTRY[$ "remove_background"] : false;
			var smooth=variable_struct_exists(ENTRY,"is_smooth") ? ENTRY[$ "is_smooth"] : false;
			var orig_x=variable_struct_exists(ENTRY,"origin_x") ? ENTRY[$ "origin_x"] : 0;
			var orig_y=variable_struct_exists(ENTRY,"origin_y") ? ENTRY[$ "origin_y"] : 0;

			if(is_real(remove_back)){
				remove_back=(remove_back!=0);
			}
			if(is_real(smooth)){
				smooth=(smooth!=0);
			}

			if(key!=""){
				var src_path=BASE+src;
				if(file_exists(src_path)){
					var SPR=sprite_add(src_path,img_num,remove_back,smooth,orig_x,orig_y);
					if(sprite_exists(SPR)){
						var VALUE=ds_map_find_value(global._gmu_lang_sprite,key);
						if(!is_undefined(VALUE)){
							if(sprite_exists(VALUE)){
								sprite_delete(VALUE);
							}
							ds_map_delete(global._gmu_lang_sprite,key);
						}
						ds_map_add(global._gmu_lang_sprite,key,SPR);
						OK=true;
					}
				}
			}
		}
	}

	var FONTS=MANIFEST[$ "fonts"];
	if(is_array(FONTS)){
		for(var f=0;f<array_length(FONTS);f+=1){
			var FONT_REF=FONTS[f];
			var fkey="";
			var REG=undefined;

			if(is_string(FONT_REF)){
				if(!variable_struct_exists(global._gmu_font_registry,FONT_REF)){
					continue;
				}
				fkey=FONT_REF;
				REG=global._gmu_font_registry[$ FONT_REF];
			}else if(is_struct(FONT_REF)){
				var ID="";
				if(variable_struct_exists(FONT_REF,"id")){
					ID=FONT_REF[$ "id"];
				}else if(variable_struct_exists(FONT_REF,"key")){
					ID=FONT_REF[$ "key"];
				}
				if(!is_string(ID)||!variable_struct_exists(global._gmu_font_registry,ID)){
					continue;
				}
				fkey=ID;
				REG=global._gmu_font_registry[$ ID];
			}else{
				continue;
			}

			if(!is_struct(REG)){
				continue;
			}

			var fsrc=variable_struct_exists(REG,"source") ? REG[$ "source"] : "";
			var is_sprite=variable_struct_exists(REG,"is_sprite") ? REG[$ "is_sprite"] : false;
			var size=variable_struct_exists(REG,"size") ? REG[$ "size"] : 12;
			var bold=variable_struct_exists(REG,"bold") ? REG[$ "bold"] : false;
			var italic=variable_struct_exists(REG,"italic") ? REG[$ "italic"] : false;
			var first=variable_struct_exists(REG,"first") ? REG[$ "first"] : 32;
			var last=variable_struct_exists(REG,"last") ? REG[$ "last"] : 128;
			var string_map=variable_struct_exists(REG,"string_map") ? REG[$ "string_map"] : "";
			var is_proportional=variable_struct_exists(REG,"is_proportional") ? REG[$ "is_proportional"] : false;
			var separation=variable_struct_exists(REG,"separation") ? REG[$ "separation"] : 0;

			if(is_struct(FONT_REF)&&!is_string(FONT_REF)){
				if(variable_struct_exists(FONT_REF,"size")) size=FONT_REF[$ "size"];
				if(variable_struct_exists(FONT_REF,"bold")) bold=FONT_REF[$ "bold"];
				if(variable_struct_exists(FONT_REF,"italic")) italic=FONT_REF[$ "italic"];
				if(variable_struct_exists(FONT_REF,"first")) first=FONT_REF[$ "first"];
				if(variable_struct_exists(FONT_REF,"last")) last=FONT_REF[$ "last"];
				if(variable_struct_exists(FONT_REF,"string_map")) string_map=FONT_REF[$ "string_map"];
				if(variable_struct_exists(FONT_REF,"is_proportional")) is_proportional=FONT_REF[$ "is_proportional"];
				if(variable_struct_exists(FONT_REF,"separation")) separation=FONT_REF[$ "separation"];
				if(variable_struct_exists(FONT_REF,"source")) fsrc=FONT_REF[$ "source"];
				if(variable_struct_exists(FONT_REF,"is_sprite")) is_sprite=FONT_REF[$ "is_sprite"];
			}

			if(is_real(is_sprite)) is_sprite=(is_sprite!=0);
			if(is_real(bold)) bold=(bold!=0);
			if(is_real(italic)) italic=(italic!=0);
			if(is_real(is_proportional)) is_proportional=(is_proportional!=0);

			if(fkey==""){
				continue;
			}

			var FONT=-1;
			if(!is_sprite){
				var font_path=global._gmu_included_root+"font/"+fsrc;
				if(file_exists(font_path)){
					FONT=font_add(font_path,size,bold,italic,first,last);
				}
			}else if(Lang_IsSpriteExists(fsrc)){
				if(string_map==""){
					FONT=font_add_sprite(Lang_GetSprite(fsrc),first,is_proportional,separation);
				}else{
					FONT=font_add_sprite_ext(Lang_GetSprite(fsrc),string_map,is_proportional,separation);
				}
			}

			if(font_exists(FONT)){
				var FONT_VALUE=ds_map_find_value(global._gmu_lang_font,fkey);
				if(!is_undefined(FONT_VALUE)){
					if(font_exists(FONT_VALUE)){
						font_delete(FONT_VALUE);
					}
					ds_map_delete(global._gmu_lang_font,fkey);
				}
				ds_map_add(global._gmu_lang_font,fkey,FONT);
				OK=true;
			}
		}
	}

	var AUDIOS=MANIFEST[$ "audio"];
	if(is_array(AUDIOS)){
		for(var a=0;a<array_length(AUDIOS);a+=1){
			var AENTRY=AUDIOS[a];
			if(!is_struct(AENTRY)){
				continue;
			}
			var akey=variable_struct_exists(AENTRY,"key") ? AENTRY[$ "key"] : "";
			var asrc=variable_struct_exists(AENTRY,"source") ? AENTRY[$ "source"] : "";
			if(akey!=""&&asrc!=""){
				var apath=BASE+asrc;
				if(file_exists(apath)){
					var ASND=audio_create_stream(apath);
					if(ASND!=-1&&audio_exists(ASND)){
						var AVALUE=ds_map_find_value(global._gmu_lang_audio,akey);
						if(!is_undefined(AVALUE)){
							if(is_real(AVALUE)&&AVALUE>=0&&audio_exists(AVALUE)){
								audio_destroy_stream(AVALUE);
							}
							ds_map_delete(global._gmu_lang_audio,akey);
						}
						ds_map_add(global._gmu_lang_audio,akey,ASND);
						OK=true;
					}
				}
			}
		}
	}

	var AUDIO_DIR=BASE+"audio/";
	if(!Game_IsMobile()&&directory_exists(AUDIO_DIR)){
		var AUDIO_FILES=[];
		var AFILE=file_find_first(AUDIO_DIR+"*.ogg",0);
		while(AFILE!=""){
			array_push(AUDIO_FILES,AFILE);
			AFILE=file_find_next();
		}
		file_find_close();

		for(var ai=0;ai<array_length(AUDIO_FILES);ai+=1){
			AFILE=AUDIO_FILES[ai];
			var ADOT=string_last_pos(".",AFILE);
			var akey=AFILE;
			if(ADOT>0){
				akey=string_copy(AFILE,1,ADOT-1);
			}
			if(!Lang_IsAudioExists(akey)){
				var apath=AUDIO_DIR+AFILE;
				if(file_exists(apath)){
					var ASND=audio_create_stream(apath);
					if(ASND!=-1&&audio_exists(ASND)){
						ds_map_add(global._gmu_lang_audio,akey,ASND);
						OK=true;
					}
				}
			}
		}
	}

	return OK;
}
