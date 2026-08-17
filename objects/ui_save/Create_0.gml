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

_prefix="{shadow false}{scale 2}{font 1}{instant true}{gui true}{depth "+string(DEPTH_UI.TEXT)+"}";

_save_off_x=Lang_GetLayout("save.save_x",0);
_return_off_x=Lang_GetLayout("save.return_x",0);
_info_off_x_0=Lang_GetLayout("save.info_text_x",0,0);
_info_off_x_1=Lang_GetLayout("save.info_text_x",0,1);
_info_off_x_2=Lang_GetLayout("save.info_text_x",0,2);

_insts=[];
_hl[0]=[];
_hl[1]=[];
_hl[2]=[];
_hl[3]=[];
_inst_cur_time=noone;
_inst_ow_time=noone;
_time_str="";
_time_prefix="";

if(instance_exists(char_player)){
	char_player._moveable_save=false;
}
