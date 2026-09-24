event_inherited();

user_char=0;

//Assign in Instance Creation Code:
//_cutscene_code = function(){ cutscene_create(); ... cutscene_play(); }
//_cutscene_exit_code = function(){ ... }   // optional, on trigger leave
_cutscene_code=undefined;
_cutscene_exit_code=undefined;
_trigger_once=true;
