Anim_Init();

Input_Init();
Input_Bind(INPUT.CONFIRM,INPUT_TYPE.KEYBOARD,0,vk_enter);
Input_Bind(INPUT.CONFIRM,INPUT_TYPE.KEYBOARD,0,ord("Z"));
Input_Bind(INPUT.CANCEL,INPUT_TYPE.KEYBOARD,0,vk_shift);
Input_Bind(INPUT.CANCEL,INPUT_TYPE.KEYBOARD,0,ord("X"));
Input_Bind(INPUT.MENU,INPUT_TYPE.KEYBOARD,0,vk_control);
Input_Bind(INPUT.MENU,INPUT_TYPE.KEYBOARD,0,ord("C"));
Input_Bind(INPUT.UP,INPUT_TYPE.KEYBOARD,0,vk_up);
Input_Bind(INPUT.DOWN,INPUT_TYPE.KEYBOARD,0,vk_down);
Input_Bind(INPUT.LEFT,INPUT_TYPE.KEYBOARD,0,vk_left);
Input_Bind(INPUT.RIGHT,INPUT_TYPE.KEYBOARD,0,vk_right);

Lang_Init();
Lang_LoadList();
Item_Init();
Storage_Init();
Storage_LoadSettings();
Lang_LoadAgain();

var z=Storage_GetTempGeneral();
z.Set(FLAG_TEMP_OLD_PERSISTENT_ROOM,-1);

Encounter_Init();
BGM_Init();
Dialog_Init();
Cutscene_Init();
Shop_Init();
Border_Custom();

instance_create_depth(0,0,0,camera);
instance_create_depth(0,0,0,fader);
instance_create_depth(0,0,0,border);
instance_create_depth(0,0,0,closed_captions);
instance_create_depth(0,0,0,debugger);

application_surface_draw_enable(false);

var b=Storage_GetSettingsGeneral();
Border_SetEnabled(b.Get(FLAG_SETTINGS_BORDER,0)>0? 1 : 0);

//show_debug_overlay(true);
randomize();
room_goto_next();
