if(!_ended){
	alarm[0]=10;
	fader.color=_fade_color;
	Fader_Fade(-1,1,9);
	BGM_SetVolume(5,0,9);
	_ended=true;
}