event_inherited();

char_id=0;

dir=DIR_CHAR.DOWN;

res_idle_sprite[DIR_CHAR.UP]=spr_char_frisk_up;
res_idle_sprite[DIR_CHAR.DOWN]=spr_char_frisk_down;
res_idle_sprite[DIR_CHAR.LEFT]=spr_char_frisk_left;
res_idle_sprite[DIR_CHAR.RIGHT]=spr_char_frisk_right;
res_move_sprite[DIR_CHAR.UP]=spr_char_frisk_up;
res_move_sprite[DIR_CHAR.DOWN]=spr_char_frisk_down;
res_move_sprite[DIR_CHAR.LEFT]=spr_char_frisk_left;
res_move_sprite[DIR_CHAR.RIGHT]=spr_char_frisk_right;

move_speed[DIR_CHAR.UP]=3;
move_speed[DIR_CHAR.DOWN]=3;
move_speed[DIR_CHAR.LEFT]=3;
move_speed[DIR_CHAR.RIGHT]=3;

res_idle_flip_x[DIR_CHAR.LEFT]=false;
res_move_flip_x[DIR_CHAR.LEFT]=false;

moveable=true;
_moveable_dialog=true;
_moveable_menu=true;
_moveable_save=true;
_moveable_warp=true;
_moveable_encounter=true;
_moveable_cutscene=true;
_moveable_box=true;
