var z=Storage_GetTempGeneral();
var sx=z.Get(FLAG_TEMP_GAMEOVER_SOUL_X,320);
var sy=z.Get(FLAG_TEMP_GAMEOVER_SOUL_Y,240);

for(var i=0;i<6;i+=1){
	BGM_Stop(i);
}
audio_stop_all();

var inst=instance_create_depth(sx,sy,0,soul_break);
alarm[0]=inst.time;

_inst_text=noone;
_dialog_speed=Lang_GetLayout("speed.slow",0);
_bg_alpha=0;

if(instance_exists(fader)){
	fader.alpha=0;
}
