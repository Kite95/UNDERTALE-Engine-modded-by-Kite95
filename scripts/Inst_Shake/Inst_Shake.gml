///@arg inst
///@arg shake_x
///@arg shake_y
///@arg shake_speed_x
///@arg shake_speed_y
///@arg delay*
///@arg shake_random_x*
///@arg shake_random_y*
///@arg shake_decrease_x*
///@arg shake_decrease_y*
function Inst_Shake() {
	var INST=argument[0];
	var X=argument[1];
	var Y=argument[2];
	var SPEED_X=argument[3];
	var SPEED_Y=argument[4];
	var DELAY=0;
	var RANDOM_X=false;
	var RANDOM_Y=false;
	var DECREASE_X=1;
	var DECREASE_Y=1;
	if(argument_count>=6){
		DELAY=argument[5];
	}
	if(argument_count>=7){
		RANDOM_X=argument[6];
	}
	if(argument_count>=8){
		RANDOM_Y=argument[7];
	}
	if(argument_count>=9){
		DECREASE_X=argument[8];
	}
	if(argument_count>=10){
		DECREASE_Y=argument[9];
	}

	if(!instance_exists(INST)){
		return false;
	}

	var HELPER=noone;
	with(shaker){
		if(target==INST){
			HELPER=id;
			break;
		}
	}
	if(!instance_exists(HELPER)){
		HELPER=instance_create_depth(0,0,0,shaker);
		HELPER.target=INST;
	}else if(instance_exists(INST)){
		INST.x-=HELPER._applied_x;
		INST.y-=HELPER._applied_y;
	}

	HELPER._applied_x=0;
	HELPER._applied_y=0;
	HELPER.shake_x=X;
	HELPER.shake_y=Y;
	HELPER.shake_speed_x=SPEED_X;
	HELPER.shake_speed_y=SPEED_Y;
	HELPER.shake_random_x=RANDOM_X;
	HELPER.shake_random_y=RANDOM_Y;
	HELPER.shake_decrease_x=DECREASE_X;
	HELPER.shake_decrease_y=DECREASE_Y;
	HELPER.delay=DELAY;
	HELPER._shake_pos_x=0;
	HELPER._shake_pos_y=0;
	HELPER._shake_time_x=0;
	HELPER._shake_time_y=0;
	HELPER._shake_positive_x=true;
	HELPER._shake_positive_y=true;

	return true;


}
