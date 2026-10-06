if(!GAME_DEBUG){
	_clear_chord();
	exit;
}

if(instance_exists(debugger_list)){
	_clear_chord();
	exit;
}

if(!keyboard_check(vk_tab)){
	_clear_chord();
	exit;
}

_armed=true;
_tip="";
alarm[0]=-1;

var held_code=[];
var held_label=[];
var held_n=0;
var key_n=array_length(_key_code);
for(var i=0;i<key_n;i+=1){
	if(keyboard_check_direct(_key_code[i])){
		held_code[held_n]=_key_code[i];
		held_label[held_n]=_key_label[i];
		held_n+=1;
	}
}

var next=[];
var prev_n=array_length(_chord_keys);
for(var i=0;i<prev_n;i+=1){
	if(array_length(next)>=2){
		break;
	}
	var prev=_chord_keys[i];
	for(var j=0;j<held_n;j+=1){
		if(held_code[j]==prev.code){
			array_push(next,prev);
			break;
		}
	}
}
for(var i=0;i<held_n;i+=1){
	if(array_length(next)>=2){
		break;
	}
	var found=false;
	var next_n=array_length(next);
	for(var j=0;j<next_n;j+=1){
		if(next[j].code==held_code[i]){
			found=true;
			break;
		}
	}
	if(!found){
		array_push(next,{
			code:held_code[i],
			label:held_label[i]
		});
	}
}
_chord_keys=next;

_cur_key="";
if(array_length(_chord_keys)==1){
	_cur_key=string_lower(_chord_keys[0].label);
}

if(_cur_key==""||!variable_struct_exists(_commands,_cur_key)){
	_charge=0;
	exit;
}

var cmd=_commands[$ _cur_key];
var hold_need=_hold;
if(variable_struct_exists(cmd,"hold")){
	hold_need=cmd.hold;
}
if(hold_need<=0){
	hold_need=0.01;
}

_charge+=delta_time/1000000;
if(_charge>=hold_need){
	if(variable_struct_exists(cmd,"run")&&is_method(cmd.run)){
		cmd.run();
	}
	var text=cmd.name;
	if(variable_struct_exists(cmd,"tip")&&is_method(cmd.tip)){
		text=cmd.tip();
	}
	var hold=0;
	var fade=20;
	if(variable_struct_exists(cmd,"time")){
		hold=cmd.time;
		if(is_method(hold)){
			hold=hold();
		}
	}
	if(variable_struct_exists(cmd,"fade")){
		fade=cmd.fade;
		if(is_method(fade)){
			fade=fade();
		}
	}
	_show_tip(text,hold,fade);
	_clear_chord();
	keyboard_clear(vk_tab);
}
