_menu=0;
_mode=0;

_prefix="{gui true}{instant true}{shadow false}{font 1}{scale 2}{depth "+string(DEPTH_UI.TEXT)+"}";
_prefix_outline=_prefix+"{outline true}{color_outline `black`}";

_inst_instruction=noone;
_inst_begin=noone;
_inst_settings=noone;
_inst_name=noone;
_inst_lv=noone;
_inst_time=noone;
_inst_room=noone;
_inst_continue=noone;
_inst_reset=noone;
_inst_settings=noone;
_inst_title=noone;
_inst_copy=noone;
_inst_erase=noone;


_inst_slot_name[0]=noone;
_inst_slot_name[1]=noone;
_inst_slot_name[2]=noone;
_inst_slot_lv[0]=noone;
_inst_slot_lv[1]=noone;
_inst_slot_lv[2]=noone;
_inst_slot_time[0]=noone;
_inst_slot_time[1]=noone;
_inst_slot_time[2]=noone;
_inst_slot_room[0]=noone;
_inst_slot_room[1]=noone;
_inst_slot_room[2]=noone;
_inst_slot_continue=noone;
_inst_slot_reset=noone;

_inst_naming_title=noone;
_inst_naming_letters=noone;
_inst_naming_quit=noone;
_inst_naming_backspace=noone;
_inst_naming_done=noone;

_inst_confirm_title=noone;
_inst_confirm_yes=noone;
_inst_confirm_no=noone;

_choice=0;
_choice_restore=-1;
_choice_naming=0;
_choice_naming_letter=0;
_choice_naming_command=0;
_choice_confirm=0;
_choice_file=0;
_slot_choice=0;
_slot_open=false;
_file_action=0;
_copy_from=-1;
_copy_to=-1;
_erase_slot=-1;
_hint_timer=0;
_hint_title="";
_slot_peek[0]=-1;
_slot_peek[1]=-1;
_slot_peek[2]=-1;

_confirm_title="";
_confirm_valid=true;
_confirm_name_x=0;
_confirm_name_y=0;
_confirm_name_scale=0;
_confirm_name_offset_x=0;
_confirm_name_offset_y=0;
_confirm_name_angle=0;
_confirm_name_update=true;

_naming_name="";

_change_inst=noone;
_change_color=c_white;
_change_id=-1;

event_user(0);