///@arg audio_id  return value from SFX_Play
function SFX_Stop() {
	var AUDIO=argument[0];
	if(AUDIO<0)return false;
	if(!audio_is_playing(AUDIO))return false;
	audio_stop_sound(AUDIO);
	return true;


}
