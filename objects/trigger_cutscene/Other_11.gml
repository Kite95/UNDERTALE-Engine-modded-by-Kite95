///@desc Leave
if(!_trigger_once){
	_triggered=false;
}
if(cutscene_is_playing()){
	exit;
}
if(is_method(_cutscene_exit_code)){
	_cutscene_exit_code();
}
