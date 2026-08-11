if(!instance_exists(_inst)){
	if(!Dialog_IsEmpty()){
		_inst=instance_create_depth(_dialog_x,_dialog_y,0,text_typer);
		_inst.text="{scale 2}{voice 0}{speed "+string(_dialog_speed)+"}{space_y 2}{gui true}{depth "+string(DEPTH_UI.TEXT)+"}";
		_inst.text+=Dialog_Get();
		_inst.text+="{pause}{end}";
	}else{
		instance_destroy();
	}
}