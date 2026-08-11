///@desc Trigger
event_inherited();
if(cutscene_is_playing())exit;

if(is_method(_cutscene_code)){
	_cutscene_code();
}
