depth=DEPTH_UI.PANEL;

_state=-1;
_choice=0;

_prefix="{shadow false}{scale 2}{font 1}{instant true}{gui true}{depth "+string(DEPTH_UI.TEXT)+"}";

_save_off_x=Lang_GetLayout("save.save_x",0);
_return_off_x=Lang_GetLayout("save.return_x",0);
_info_off_x_0=Lang_GetLayout("save.info_text_x",0,0);
_info_off_x_1=Lang_GetLayout("save.info_text_x",0,1);
_info_off_x_2=Lang_GetLayout("save.info_text_x",0,2);

_inst_name=noone;
_inst_lv=noone;
_inst_time=noone;
_inst_room=noone;
_inst_save=noone;
_inst_return=noone;

if(instance_exists(char_player)){
	char_player._moveable_save=false;
}