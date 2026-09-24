Storage_SetSlot(_slot_choice);
Storage_GetStatic().ClearData();
var sDynamic=Storage_GetDynamic();
sDynamic.ClearData();
sDynamic.LoadFromFile();
Static_CustomInitialData();
Plot_CustomInitialData();
Player_SetName(_naming_name);
var random_fun=floor(random_range(0,100));
Player_SetFun(random_fun);

fader.color=c_black;
Fader_Fade(-1,0,10);
room_goto_next();