var i=0;
repeat(array_length(_insts)){
	if(instance_exists(_insts[i])){
		instance_destroy(_insts[i]);
	}
	i+=1;
}

if(instance_exists(char_player)){
	char_player._moveable_save=true;
}
