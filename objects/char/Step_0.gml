var proc=0;
var _did_move=false;
repeat(4){
	if(move[proc]>0){
		if(!dir_locked){
			dir=proc;
		}
		var move_x=0;
		var move_y=0;
		if(proc==DIR_CHAR.UP || proc==DIR_CHAR.DOWN){
			move_y=1*(proc==DIR_CHAR.UP ? -1 : 1);
		}else if(proc==DIR_CHAR.LEFT || proc==DIR_CHAR.RIGHT){
			move_x=1*(proc==DIR_CHAR.LEFT ? -1 : 1);
		}
		repeat(move_speed[proc]*1){
			var cmove=true;
			if(collision){
				var list=_collision_list;
				ds_list_clear(list);
				var num=instance_place_list(x+move_x,y+move_y,block,list,false);
				var procl=0;
				repeat(num){
					var inst=list[|procl];
					if(instance_exists(inst)){
						if(inst.block_enabled){
							cmove=false;
							break;
						}
					}
					procl+=1;
				}
			}
			if(cmove){
				x+=move_x;
				y+=move_y;
				_did_move=true;
			}else{
				break;
			}
		}
		move[proc]-=1;
	}
	proc+=1;
}
x=round(x);
y=round(y);

var _want_move_anim=_did_move;

if(_want_move_anim){
	_move_finish=false;
}else if(_move_any_previous || _move_finish){
	var _move_spr=res_move_sprite[dir];
	if(_move_finish || (sprite_index==_move_spr && res_move_speed[dir]>0)){
		_move_finish=true;
		var _frame_end=floor(image_index)+1;
		if(image_speed<=0 || image_index+image_speed>=_frame_end){
			_move_finish=false;
		}
	}else{
		_move_finish=false;
	}
}else{
	_move_finish=false;
}

var _show_move=(_want_move_anim || _move_finish);
var refresh=((dir!=_dir_previous || talking!=_talking_previous || _show_move!=_move_any_previous) && !res_override);

if(refresh){
	if(_show_move){
		sprite_index=res_move_sprite[dir];
		image_index=res_move_image[dir];
		image_speed=res_move_speed[dir];
		image_xscale*=((res_move_flip_x[dir]&&sign(image_xscale)==1)||(!res_move_flip_x[dir]&&sign(image_xscale)==-1) ? -1 : 1);
	}else if(talking){
		sprite_index=res_talk_sprite[dir];
		image_index=res_talk_image[dir];
		image_speed=res_talk_speed[dir];
		image_xscale*=((res_talk_flip_x[dir]&&sign(image_xscale)==1)||(!res_talk_flip_x[dir]&&sign(image_xscale)==-1) ? -1 : 1);
	}else{
		sprite_index=res_idle_sprite[dir];
		image_index=res_idle_image[dir];
		image_speed=res_idle_speed[dir];
		image_xscale*=((res_idle_flip_x[dir]&&sign(image_xscale)==1)||(!res_idle_flip_x[dir]&&sign(image_xscale)==-1) ? -1 : 1);
	}
}

_talking_previous=talking;
_dir_previous=dir;
_move_any_previous=_show_move;
