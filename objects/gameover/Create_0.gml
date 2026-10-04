var z=Storage_GetTempGeneral();
var sx=z.Get(FLAG_TEMP_GAMEOVER_SOUL_X,320);
var sy=z.Get(FLAG_TEMP_GAMEOVER_SOUL_Y,240);

instance_create_depth(sx,sy,0,gameover_anim);

_inst=noone;
_phase=0;
_bg_alpha=0;

if(instance_exists(fader)){
	fader.alpha=0;
}
