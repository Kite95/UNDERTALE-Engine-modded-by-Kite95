if(!GAME_DEBUG){
	exit;
}

if(_show_blocks){
	var mark_obj=[block,trigger,battle_bullet,battle_soul];
	var mark_col=[c_aqua,c_fuchsia,c_lime,c_yellow];
	for(var i=0;i<array_length(mark_obj);i+=1){
		var col=mark_col[i];
		with(mark_obj[i]){
			var draw_col=col;
			if(variable_instance_exists(id,"block_enabled")&&!block_enabled){
				draw_col=c_orange;
			}
			draw_set_color(draw_col);
			var x1=floor(bbox_left);
			var y1=floor(bbox_top);
			var x2=floor(bbox_right);
			var y2=floor(bbox_bottom);
			draw_set_alpha(0.35);
			draw_rectangle(x1,y1,x2,y2,false);
			draw_set_alpha(0.9);
			draw_rectangle(x1,y1,x2,y2,true);
		}
	}
	draw_set_alpha(1);
	draw_set_color(c_white);
}

if(_show_char_pos){
	draw_set_font(font_crypt_of_tomorrow);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_alpha(1);
	for(var i=0;i<array_length(_char_pos);i+=1){
		with(_char_pos[i]){
			draw_text(x-20,y-20,string(floor(x))+"\n"+string(floor(y)));
		}
	}
}
