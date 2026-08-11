/// First-run defaults for settings.json (global, not per save slot).
function Settings_CustomInitialData(){
    var s=Storage_GetSettings();
    if (!s.IsFileExists()){
        var general=Storage_GetSettingsGeneral();
        // language — locale folder name under datafiles/locale/ (e.g. "english", "schinese")
        general.Set(FLAG_SETTINGS_LANGUAGE,"english");
		// border — 0 = no border; 1+ = border style index (see Border_SetEnabled)
		general.Set(FLAG_SETTINGS_BORDER,0);

        s.SaveToFile();
    }
}
