if(Border_IsDynamic(Storage_GetSettingsGeneral().Get(FLAG_SETTINGS_BORDER,0))){

	if(sprite_exists(sprite)){

		if(border._sprite!=sprite){

			Border_SetSprite(sprite);

		}

	}else if(border._sprite!=-1){

		Border_SetSprite(-1);

	}

}

