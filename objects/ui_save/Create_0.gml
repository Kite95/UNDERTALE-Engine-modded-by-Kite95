depth=DEPTH_UI.PANEL;

_state=-1;
_choice=0;
_slot_choice=0;
_overwrite_choice=0;
_save_target_slot=0;
_buffer=0;
_slot_peek[0]=-1;
_slot_peek[1]=-1;
_slot_peek[2]=-1;

_prefix="{scale 2}{font 1}{instant true}{gui true}{depth "+string(DEPTH_UI.TEXT)+"}";

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
_inst_overwrite_return=noone;

_inst_slot[0]=noone;
_inst_slot[1]=noone;
_inst_slot[2]=noone;
_inst_slot_lv[0]=noone;
_inst_slot_lv[1]=noone;
_inst_slot_lv[2]=noone;
_inst_slot_name[0]=noone;
_inst_slot_name[1]=noone;
_inst_slot_name[2]=noone;
_inst_slot_time[0]=noone;
_inst_slot_time[1]=noone;
_inst_slot_time[2]=noone;
_inst_slot_room[0]=noone;
_inst_slot_room[1]=noone;
_inst_slot_room[2]=noone;

_inst_overwrite=noone;
_inst_old_lv=noone;
_inst_old_name=noone;
_inst_old_time=noone;
_inst_old_room=noone;
_inst_new_lv=noone;
_inst_new_name=noone;
_inst_new_time=noone;
_inst_new_room=noone;

_time_str="";
_time_prefix="";

if(instance_exists(char_player)){
	char_player._moveable_save=false;
}
