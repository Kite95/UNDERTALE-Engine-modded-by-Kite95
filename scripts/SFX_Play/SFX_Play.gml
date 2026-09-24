///@arg sound        asset or array of assets (random pick, max 10)
///@arg priority*    (default false)
///@arg loop*        (default false)
function SFX_Play() {
	var SOUND=argument[0];
	var PRIORITY=false;
	var LOOP=false;
	if(argument_count>1)PRIORITY=argument[1];
	if(argument_count>2)LOOP=argument[2];

	if(is_array(SOUND)){
		var N=array_length(SOUND);
		if(N<=0)return -1;
		if(N>10)N=10;
		SOUND=SOUND[irandom_range(0,N-1)];
	}
	if(!audio_exists(SOUND))return -1;

	var AUDIO=audio_play_sound(SOUND,PRIORITY,LOOP);
	audio_sound_gain(AUDIO,SFX_GetGain(),0);
	return AUDIO;


}
