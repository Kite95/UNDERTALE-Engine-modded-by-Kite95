if(_menu==0){
	if(_mode==2){
		var i=0;
		var col=c_gray;
		repeat(3){
			col=c_gray;
			if(_file_action==6&&i==_erase_slot){
				col=c_red;
			}else if((_file_action==2||_file_action==3)&&i==_copy_from){
				col=c_yellow;
			}else if(_choice==i){
				col=c_white;
			}
			draw_sprite_ext(spr_pixel,0,104,93+i*92,432,92,0,c_black,1);
			draw_sprite_ext(spr_pixel,0,106,95+i*92,428,88,0,col,1);
			draw_sprite_ext(spr_pixel,0,110,99+i*92,420,80,0,c_black,1);
			i+=1;
		}
		
		var inst=noone;
		if(_choice<3){
			if(_slot_open||_file_action==3||_file_action==5||_file_action==6){
				if(_choice_file==0){
					inst=_inst_slot_continue;
				}else{
					inst=_inst_slot_reset;
				}
				if(instance_exists(inst)){
					draw_sprite_ext(spr_soul_small,0,inst.x+inst._align_offset_x-18,inst.y+18,2,2,0,c_white,1);
				}
			}else{
				draw_sprite_ext(spr_soul_small,0,135,137+_choice*92,2,2,0,c_white,1);
			}
		}else if(_choice==3){
			inst=_inst_copy;
		}else if(_choice==4){
			inst=_inst_erase;
		}else{
			inst=_inst_settings;
		}
		if(_choice>=3){
			if(instance_exists(inst)){
				draw_sprite_ext(spr_soul_small,0,inst.x+inst._align_offset_x-18,inst.y+18,2,2,0,c_white,1);
			}
		}
	}
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_set_font(font_crypt_of_tomorrow);
	draw_set_color(c_gray);
	draw_text_transformed(320,476,"UNDERTALE (C) TOBY FOX 2015-2019\nUNDERTALE ENGINE "+ENGINE_VERSION+" BY "+ENGINE_AUTHOR,2,2,0);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

if(_menu==1){
	draw_set_color(c_white);
	draw_set_font(Lang_GetTyperFont("menu","ascii"));
	draw_text_transformed(280,110,_naming_name,2,2,0);
}

if(_menu==2||_menu==3){
	draw_set_color(c_white);
	draw_set_font(Lang_GetTyperFont("menu","ascii"));
	draw_text_transformed(_confirm_name_x+_confirm_name_offset_x,_confirm_name_y+_confirm_name_offset_y,_naming_name,_confirm_name_scale,_confirm_name_scale,_confirm_name_angle);
}