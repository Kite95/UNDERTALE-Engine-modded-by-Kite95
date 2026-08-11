/// Default temp/general values (not saved).
function Temp_CustomInitialData(){
	var z=Storage_GetTempGeneral();
	z.Set(FLAG_TEMP_ENCOUNTER,0);
	z.Set(FLAG_TEMP_BATTLE_ROOM_RETURN,-1);
	z.Set(FLAG_TEMP_GAMEOVER_SOUL_X,320);
	z.Set(FLAG_TEMP_GAMEOVER_SOUL_Y,240);
	z.Set(FLAG_TEMP_TRIGGER_WARP_LANDMARK,-1);
	z.Set(FLAG_TEMP_TRIGGER_WARP_DIR,-1);
	z.Set(FLAG_TEMP_TEXT_TYPER_CHOICE,-1);
	z.Set(FLAG_TEMP_OLD_PERSISTENT_ROOM,-1);
	z.Set(FLAG_TEMP_SHOP,0);
	z.Set(FLAG_TEMP_SHOP_ROOM_RETURN,-1);
}
