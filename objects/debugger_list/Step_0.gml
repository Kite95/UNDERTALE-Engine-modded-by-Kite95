if(!GAME_DEBUG){
	instance_destroy();
	exit;
}
if(array_length(_rows)<=0&&!search_enabled){
	instance_destroy();
	exit;
}

Debugger_ListUpdateLayout(id);
if(Debugger_ListStepSearch(id)){
	exit;
}
Debugger_ListStepNav(id);
