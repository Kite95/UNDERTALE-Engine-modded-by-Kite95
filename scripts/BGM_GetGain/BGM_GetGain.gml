function BGM_GetGain() {
	var SET=Storage_GetSettingsGeneral();
	var MASTER=SET.Get(FLAG_SETTINGS_MASTER_VOLUME,100);
	var VOLUME=SET.Get(FLAG_SETTINGS_BGM_VOLUME,100);

	if(MASTER<0){
		MASTER=0;
	}
	if(VOLUME<0){
		VOLUME=0;
	}
	return (MASTER/100)*(VOLUME/100);


}
