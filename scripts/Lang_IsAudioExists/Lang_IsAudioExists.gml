///@arg audio_name
function Lang_IsAudioExists() {
	var KEY=argument[0];

	var VALUE=ds_map_find_value(global._gmu_lang_audio,KEY);
	return audio_exists(is_real(VALUE) ? VALUE : -1);


}
