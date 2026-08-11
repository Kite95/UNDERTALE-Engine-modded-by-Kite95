/// Default info.json values (menu file-select display before load).
function Info_CustomInitialData(){
	var z=Storage_GetInfoGeneral();
	z.Set(FLAG_INFO_NAME,"CHARA");
	z.Set(FLAG_INFO_LV,1);
	z.Set(FLAG_INFO_TIME,0);
	z.Set(FLAG_INFO_ROOM,"");
}
