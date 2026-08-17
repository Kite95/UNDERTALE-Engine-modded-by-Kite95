if(_state==0||_state==1){
	draw_sprite_ext(spr_pixel,0,108,118,424,174,0,c_white,1);
	draw_sprite_ext(spr_pixel,0,108+6,118+6,424-6*2,174-6*2,0,c_black,1);
}

if(_state==0){
	if(_choice==0){
		draw_sprite(spr_battle_soul_red,0,108+6+37+_save_off_x,118+6+131);
	}else{
		draw_sprite(spr_battle_soul_red,0,108+6+217+_return_off_x,118+6+131);
	}
}

if(_state==10||_state==11||_state==12){
	draw_sprite_ext(spr_pixel,0,0,0,640,480,0,c_black,0.8);
	
	draw_sprite_ext(spr_pixel,0,68,20,506,90,0,c_white,1);
	draw_sprite_ext(spr_pixel,0,74,26,494,78,0,c_black,1);
	
	draw_sprite_ext(spr_pixel,0,68,132,506,258,0,c_white,1);
	draw_sprite_ext(spr_pixel,0,74,138,494,78,0,c_black,1);
	draw_sprite_ext(spr_pixel,0,74,222,494,78,0,c_black,1);
	draw_sprite_ext(spr_pixel,0,74,306,494,78,0,c_black,1);
	
	if(_state!=12){
		draw_sprite_ext(spr_pixel,0,68,384,506,54,0,c_white,1);
		draw_sprite_ext(spr_pixel,0,74,390,494,42,0,c_black,1);
	}
}

if(_state==11){
	draw_sprite_ext(spr_pixel,0,18,108,604,264,0,c_white,1);
	draw_sprite_ext(spr_pixel,0,24,114,592,252,0,c_black,1);
}

if(_state==10||_state==11){
	var choice=(_state==10 ? _slot_choice : _overwrite_choice);
	if(array_length(_hl[choice])>0){
		var inst=_hl[choice][0];
		if(instance_exists(inst)){
			draw_sprite(spr_battle_soul_red,0,inst.x+inst._align_offset_x-19,inst.y+15);
		}
	}
}
