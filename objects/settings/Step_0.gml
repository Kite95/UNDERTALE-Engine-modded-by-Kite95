if(Input_IsPressed(INPUT.DOWN)){
	if(_choice<2){
		_choice+=1;
		event_user(2);
	}
}else if(Input_IsPressed(INPUT.UP)){
	if(_choice>0){
		_choice-=1;
		event_user(2);
	}
}else if(Input_IsPressed(INPUT.CONFIRM)){
	if(_choice==0){
		room_goto(room_menu);
	}
}

if(_choice==1){
	if(Input_IsPressed(INPUT.RIGHT)||Input_IsPressed(INPUT.LEFT)){
		alarm[0]=1;
		var ID=Lang_GetID(Language());
		if(ID==-1) ID=0;
		ID=(ID+1)%Lang_GetNumber();
		Storage_SaveSettings(FLAG_SETTINGS_LANGUAGE,ds_list_find_value(global._gmu_lang_list,ID));
	}
}else if(_choice==2){
	var b=Storage_GetSettingsGeneral().Get(FLAG_SETTINGS_BORDER,0);
	if(Input_IsPressed(INPUT.LEFT)&&b>0){
		alarm[0]=1;
		Storage_SaveSettings(FLAG_SETTINGS_BORDER,b-1);
		Border_SetEnabled((b-1)>0?1:0);
		if(Border_IsDynamic(b-1)){
			with(hint_border){
				if(sprite_exists(sprite)){
					if(border._sprite!=sprite){
						Border_SetSprite(sprite,false);
					}
				}else if(border._sprite!=-1){
					Border_SetSprite(-1,false);
				}
			}
		}
	}else if(Input_IsPressed(INPUT.RIGHT)&&b<Border_GetCount()-1){
		alarm[0]=1;
		Storage_SaveSettings(FLAG_SETTINGS_BORDER,b+1);
		Border_SetEnabled((b+1)>0?1:0);
		if(Border_IsDynamic(b+1)){
			with(hint_border){
				if(sprite_exists(sprite)){
					if(border._sprite!=sprite){
						Border_SetSprite(sprite,false);
					}
				}else if(border._sprite!=-1){
					Border_SetSprite(-1,false);
				}
			}
		}
	}
}
