depth=DEPTH_UI.PANEL;
if(instance_exists(char_player)){
	_top=(char_player.y-camera.y>130+char_player.sprite_height);
	char_player._moveable_dialog=false;
}else{
	_top=false;
}

_dialog_x=60+Lang_GetLayout("dialog.x",0);
_dialog_y=(_top ? 30 : 340)+Lang_GetLayout(_top ? "dialog.y_top" : "dialog.y_bottom",0);
_dialog_speed=Lang_GetLayout("speed.dialog_overworld",0);

_inst=noone;