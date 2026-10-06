if(_inst_text!=noone&&!instance_exists(_inst_text)){
	if(Input_IsPressed(INPUT.CONFIRM)){
		_inst_text=noone;
		Fader_Fade(0,1,50);
		alarm[2]=50;
	}
}
