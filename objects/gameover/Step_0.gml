if(_phase==1&&!instance_exists(_inst)){
	_phase=2;
}else if(_phase==2){
	if(Input_IsPressed(INPUT.CONFIRM)){
		_phase=3;
		Fader_Fade(0,1,50);
		alarm[4]=50;
	}
}
