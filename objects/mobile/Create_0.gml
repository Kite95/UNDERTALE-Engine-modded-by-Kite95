_active=Game_IsMobile();
depth=DEPTH_UI.GUI;

_use_stick=false;
_btn_layout=0;

_off_stick_x=0;
_off_stick_y=360;
_off_btn_x=0;
_off_btn_y=400;
_stick_dead=20;
_margin=36;
_scale=3;

_alpha=0.72;
_hit_pad=14;
_stick_grab=18;
_dpad_gap=18;
_dpad_gap_x=6;
_btn_step=13;
_btn_gap=10;

_stick_device=-1;

_btn_input=[INPUT.CONFIRM,INPUT.CANCEL,INPUT.MENU];
_btn_spr=[spr_mobile_zkey,spr_mobile_xkey,spr_mobile_ckey];
_btn_x=array_create(3);
_btn_y=array_create(3);
_btn_held=array_create(3,false);

_dpad_input=[INPUT.UP,INPUT.DOWN,INPUT.LEFT,INPUT.RIGHT];
_dpad_spr=[spr_mobile_upkey,spr_mobile_downkey,spr_mobile_leftkey,spr_mobile_rightkey];
_dpad_x=array_create(4);
_dpad_y=array_create(4);
_dpad_held=array_create(4,false);
