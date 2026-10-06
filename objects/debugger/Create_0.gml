depth=DEPTH_UI.DEBUG;

global.debug_busy=false;
global.debug_invincible=false;

_show_blocks=false;
_show_char_pos=false;

_armed=false;
_charge=0;
_cur_key="";
_chord_keys=[];
_hold=0.8;
_tip="";
_tip_time=20;
_tip_fade=20;

_clear_chord=function(){
	_armed=false;
	_charge=0;
	_cur_key="";
	_chord_keys=[];
};

///@arg text @arg hold* @arg fade*
_show_tip=function(){
	var text=argument[0];
	var hold=0;
	var fade=20;
	if(argument_count>=2){
		hold=argument[1];
	}
	if(argument_count>=3){
		fade=argument[2];
	}
	_tip=text;
	_tip_fade=max(1,fade);
	_tip_time=hold+_tip_fade;
	alarm[0]=_tip_time;
};

_key_code=[];
_key_label=[];
for(var i=0;i<26;i+=1){
	array_push(_key_code,ord("A")+i);
	array_push(_key_label,chr(ord("A")+i));
}
for(var i=0;i<10;i+=1){
	array_push(_key_code,ord("0")+i);
	array_push(_key_label,chr(ord("0")+i));
	array_push(_key_code,vk_numpad0+i);
	array_push(_key_label,chr(ord("0")+i));
}
var sym_code=[186,187,188,189,190,191,192,219,220,221,222];
var sym_label=[";","=",",","-",".","/","`","[","\\","]","'"];
for(var i=0;i<array_length(sym_code);i+=1){
	array_push(_key_code,sym_code[i]);
	array_push(_key_label,sym_label[i]);
}
for(var i=0;i<12;i+=1){
	array_push(_key_code,vk_f1+i);
	array_push(_key_label,"F"+string(i+1));
}

_commands={};

_commands[$ "1"]={
	name:"Restart Room",
	hold:0.6,
	run:function(){
		room_restart();
	}
};

_commands[$ "2"]={
	name:"Restart Game",
	hold:0.7,
	run:function(){
		game_restart();
	}
};

_commands[$ "3"]={
	name:"Cycle Speed",
	hold:0.4,
	run:function(){
		var spd=game_get_speed(gamespeed_fps);
		if(spd==30){
			game_set_speed(10,gamespeed_fps);
		}else if(spd==10){
			game_set_speed(3,gamespeed_fps);
		}else{
			game_set_speed(30,gamespeed_fps);
		}
	},
	tip:function(){
		return "Now in "+string(game_get_speed(gamespeed_fps))+"FPS";
	},
	time:function(){
		var spd=game_get_speed(gamespeed_fps);
		if(spd<=3){
			return 4;
		}
		if(spd<=10){
			return 10;
		}
		return 24;
	},
	fade:function(){
		var spd=game_get_speed(gamespeed_fps);
		if(spd<=3){
			return 3;
		}
		if(spd<=10){
			return 8;
		}
		return 18;
	}
};

_commands[$ "4"]={
	name:"Stop Music",
	hold:0.5,
	run:function(){
		BGM_StopAll();
	}
};

_commands[$ "r"]={
	name:"Room List",
	hold:0.5,
	run:function(){
		Debugger_ListOpenRoom();
	}
};

_commands[$ "e"]={
	name:"Encounter List",
	hold:0.5,
	run:function(){
		Debugger_ListOpenEncounter();
	}
};

_commands[$ "5"]={
	name:"End Battle",
	hold:0.5,
	run:function(){
		if(room!=room_battle){
			return;
		}
		Battle_End();
	},
	tip:function(){
		if(room!=room_battle){
			return "Not in battle";
		}
		return "Battle ended";
	}
};

_commands[$ "i"]={
	name:"Invincible",
	hold:0.4,
	run:function(){
		global.debug_invincible=!global.debug_invincible;
	},
	tip:function(){
		return global.debug_invincible?"Invincible: ON":"Invincible: OFF";
	}
};

_commands[$ "v"]={
	name:"Show Collision",
	hold:0.4,
	run:method(id,function(){
		_show_blocks=!_show_blocks;
	}),
	tip:method(id,function(){
		return _show_blocks?"Collision: ON":"Collision: OFF";
	})
};

_char_pos=[
	char_player,
	char_sign,
	char_save,
	char_box
];

_commands[$ "p"]={
	name:"Show Char Pos",
	hold:0.4,
	run:method(id,function(){
		_show_char_pos=!_show_char_pos;
	}),
	tip:method(id,function(){
		return _show_char_pos?"Char Pos: ON":"Char Pos: OFF";
	})
};

_commands[$ "h"]={
	name:"Help",
	hold:0.3,
	time:120,
	tip:method(id,function(){
		var text="";
		var keys=variable_struct_get_names(_commands);
		array_sort(keys,true);
		for(var i=0;i<array_length(keys);i+=1){
			var key=keys[i];
			var cmd=_commands[$ key];
			var hold=_hold;
			if(variable_struct_exists(cmd,"hold")){
				hold=cmd.hold;
			}
			if(text!=""){
				text+="\n";
			}
			text+="TAB+"+string_upper(key)+"  "+cmd.name+"  ("+string(hold)+"s)";
		}
		return text;
	})
};
