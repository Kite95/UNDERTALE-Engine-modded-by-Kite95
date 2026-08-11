///@desc Settings
_inst_title=instance_create_depth(160,10,0,text_typer);
_inst_title.text=_prefix+Lang_GetString("settings.title");
_inst_exit=instance_create_depth(40,80,0,text_typer);
_inst_exit.text=_prefix+Lang_GetString("settings.exit");
_inst_language_title=instance_create_depth(40,140,0,text_typer);
_inst_language_title.text=_prefix+Lang_GetString("settings.language");
_inst_language=instance_create_depth(184,140,0,text_typer);
_inst_language.text=_prefix+Lang_GetInfo(Language(),"name");
_inst_border_title=instance_create_depth(40,200,0,text_typer);
_inst_border_title.text=_prefix+Lang_GetString("settings.border");
_inst_border=instance_create_depth(184,200,0,text_typer);
_inst_border.text=_prefix+Border_GetName(Storage_GetSettingsGeneral().Get(FLAG_SETTINGS_BORDER,0));
with(text_typer){
	event_user(15);
}
event_user(2);
