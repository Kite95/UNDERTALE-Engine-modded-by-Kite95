_trigger_once=false;

_cutscene_code=function(){
	var px=char_player.x;
	var py=char_player.y;
	var cx=camera.x;

	cutscene_create();
	cutscene_player_canmove(false);

	cutscene_dialog("* Full cutscene API demo.");
	cutscene_wait(20);

	cutscene_func(function(){
		global.cutscene_demo_wait=20;
	});
	cutscene_wait_until(function(){
		if(!variable_global_exists("cutscene_demo_wait"))return true;
		global.cutscene_demo_wait-=1;
		return global.cutscene_demo_wait<=0;
	});
	cutscene_dialog("* wait / wait_until / func OK.");

	if(instance_exists(char_player)){
		cutscene_set_variable(char_player,"dir",DIR_CHAR.LEFT);
		cutscene_dialog("* set_variable (save looks left).");
		cutscene_set_variable(char_player,"dir",DIR_CHAR.DOWN);
	}

	// Just exercises the command; 0 = start / unset.

	cutscene_char_move(char_player,DIR_CHAR.RIGHT,12);
	cutscene_dialog("* char_move.");

	cutscene_char_move_to(char_player,px+48,py+50,28);
	cutscene_dialog("* char_walk_to.");

	cutscene_camera_target(noone);
	cutscene_anim(camera,"x",ANIM_TWEEN.CUBIC,ANIM_EASE.OUT,cx,30,20);
	cutscene_dialog("* camera_target + anim.");
	cutscene_camera_target(char_player);

	cutscene_fade(0,0.45,12,c_white);
	cutscene_fade(0.45,0,12,c_white);
	cutscene_dialog("* fade (white).");

	cutscene_choice("* Choice (4-way, none).{pause}{clear}{choice_anim true}{choice_dir 3}            {choice 0}我是你爹!\n  {choice 1}你是我爹吗              {choice 2}蛤蛤\n            {choice 3}弱弱？！！？",function(c){
		if(c==0){
			cutscene_dialog("* Picked A.");
			cutscene_char_move_to(char_player,char_player.x,char_player.y+20,20);
		}else{
			cutscene_dialog("* Picked B.");
			cutscene_wait(20);
		}
		if(instance_exists(char_save)){
			cutscene_set_variable(char_save,"dir",DIR_CHAR.DOWN);
		}
		cutscene_dialog("* Demo complete.");
		cutscene_player_canmove(true);
	});

	cutscene_play();
};
