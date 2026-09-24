/// Cutscene runtime + commands (single active cutscene)

function Cutscene_Init(){
	global.current_cutscene=undefined;
	return true;
}

function cutscene_is_valid(){
	var cs=(argument_count>0)?argument[0]:global.current_cutscene;
	return is_struct(cs)&&variable_struct_exists(cs,"queue");
}

function cutscene_get_current(){
	return global.current_cutscene;
}

function cutscene_is_playing(){
	var cs=global.current_cutscene;
	return cutscene_is_valid(cs)&&cs.playing;
}

function cutscene_create(){
	var _local=true;
	if(argument_count>0)_local=argument[0];
	var cs={
		queue:[],
		playing:false,
		local:_local,
		start_room:-1,
		current_event:undefined
	};
	global.current_cutscene=cs;
	return cs;
}

function cutscene_queue_event(){
	var cs=(argument_count>0&&cutscene_is_valid(argument[0]))?argument[0]:global.current_cutscene;
	var ev=(argument_count>1)?argument[1]:undefined;
	if(!cutscene_is_valid(cs)||!is_struct(ev))return false;
	array_push(cs.queue,ev);
	return true;
}

function cutscene_make_event(){
	var _call=(argument_count>0)?argument[0]:undefined;
	var _resume=(argument_count>1)?argument[1]:undefined;
	var _step=(argument_count>2)?argument[2]:undefined;
	var _finish=(argument_count>3)?argument[3]:undefined;
	return {
		call:_call,
		resume:_resume,
		step:_step,
		finish:_finish
	};
}

function cutscene_event_finish(_ev){
	if(is_struct(_ev)&&!is_undefined(_ev.finish)&&is_method(_ev.finish)){
		_ev.finish();
	}
}

function cutscene_play(){
	var cs=(argument_count>0)?argument[0]:global.current_cutscene;
	if(!cutscene_is_valid(cs))return false;
	if(cutscene_is_playing())return false; // IGNORE
	cs.playing=true;
	cs.start_room=room;
	cs.current_event=undefined;
	global.current_cutscene=cs;
	return true;
}

function cutscene_stop(){
	var cs=(argument_count>0)?argument[0]:global.current_cutscene;
	if(cutscene_is_valid(cs)){
		if(!is_undefined(cs.current_event)){
			cutscene_event_finish(cs.current_event);
			cs.current_event=undefined;
		}
		cs.queue=[];
		cs.playing=false;
	}
	if(global.current_cutscene==cs){
		global.current_cutscene=undefined;
	}
	Dialog_Clear();
	if(instance_exists(ui_dialog)){
		instance_destroy(ui_dialog);
	}
	if(instance_exists(char_player)){
		char_player._moveable_cutscene=true;
	}
	return true;
}

function Cutscene_Step(){
	var cs=global.current_cutscene;
	if(!cutscene_is_valid(cs)||!cs.playing)return;

	if(cs.local&&cs.start_room!=-1&&room!=cs.start_room){
		cutscene_stop(cs);
		return;
	}

	if(!is_undefined(cs.current_event)){
		var ev=cs.current_event;
		var done=true;
		if(!is_undefined(ev.resume)&&is_method(ev.resume)){
			done=ev.resume();
		}
		if(done){
			cutscene_event_finish(ev);
			cs.current_event=undefined;
		}else if(!is_undefined(ev.step)&&is_method(ev.step)){
			ev.step();
		}
	}

	while(is_undefined(cs.current_event)){
		if(array_length(cs.queue)<=0){
			cs.playing=false;
			global.current_cutscene=undefined;
			return;
		}
		var next=cs.queue[0];
		array_delete(cs.queue,0,1);
		cs.current_event=next;
		if(!is_undefined(next.call)&&is_method(next.call)){
			next.call();
		}
		var instant=true;
		if(!is_undefined(next.resume)&&is_method(next.resume)){
			instant=next.resume();
		}
		if(instant){
			cutscene_event_finish(next);
			cs.current_event=undefined;
		}
	}
}

///@arg can_move
function cutscene_player_canmove(){
	var can=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(method({can:can},function(){
		if(instance_exists(char_player)){
			char_player._moveable_cutscene=can;
		}
	})));
}

///@arg target
function cutscene_camera_target(){
	var tgt=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(method({tgt:tgt},function(){
		if(instance_exists(camera)){
			camera.target=tgt;
		}
	})));
}

///@arg inst
///@arg name
///@arg value
function cutscene_set_variable(){
	var inst=argument[0];
	var name=argument[1];
	var value=argument[2];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(method({inst:inst,name:name,value:value},function(){
		if(instance_exists(inst)){
			variable_instance_set(inst,name,value);
		}
	})));
}

///@arg plot
function cutscene_set_plot(){
	var plot=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(method({plot:plot},function(){
		Player_SetPlot(plot);
	})));
}

///@arg text
function cutscene_dialog(){
	var text=argument[0];
	if(!is_string(text))text=string(text);
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({text:text},function(){
			Dialog_Add(text);
			Dialog_Start();
		}),
		function(){
			return Dialog_IsEmpty()&&!instance_exists(ui_dialog);
		}
	));
}

///@arg text
///@arg callback  function(choice_index)
function cutscene_choice(){
	var text=argument[0];
	var callback=argument[1];
	if(!is_string(text))text=string(text);
	var ev=cutscene_make_event();
	ev.callback=callback;
	ev.choice_fired=false;
	ev.call=method({text:text},function(){
		Dialog_Add(text+"{choice `CHOICE`}");
		Dialog_Start();
	});
	ev.resume=method(ev,function(){
		if(!(Dialog_IsEmpty()&&!instance_exists(ui_dialog))){
			return false;
		}
		if(!choice_fired){
			choice_fired=true;
			if(is_method(callback)){
				callback(Player_GetTextTyperChoice());
			}
		}
		return true;
	});
	cutscene_queue_event(global.current_cutscene,ev);
}

///@arg frames
function cutscene_wait(){
	var _frames=argument[0];
	var ev=cutscene_make_event();
	ev.frames=_frames;
	ev.resume=method(ev,function(){
		return frames<=0;
	});
	ev.step=method(ev,function(){
		frames-=1;
	});
	cutscene_queue_event(global.current_cutscene,ev);
}

///@arg fn
function cutscene_wait_until(){
	var fn=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		undefined,
		fn
	));
}

///@arg fn
function cutscene_func(){
	var fn=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(fn));
}

///@arg inst
///@arg dir
///@arg steps
function cutscene_char_move(){
	var inst=argument[0];
	var dir=argument[1];
	var steps=argument[2];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({inst:inst,dir:dir,steps:steps},function(){
			if(instance_exists(inst)){
				inst.move[dir]=steps;
			}
		}),
		method({inst:inst,dir:dir},function(){
			if(!instance_exists(inst))return true;
			return inst.move[dir]<=0;
		})
	));
}

///@arg inst
///@arg x
///@arg y
///@arg time*   (default: distance / move_speed)
///@arg wait*   (default true)
function cutscene_char_move_to(){
	var inst=argument[0];
	var tx=argument[1];
	var ty=argument[2];
	var time=undefined;
	var wait=true;
	if(argument_count>3){
		if(is_bool(argument[3]))wait=argument[3];
		else time=argument[3];
	}
	if(argument_count>4)wait=argument[4];

	var ev=cutscene_make_event();
	ev.inst=inst;
	ev.tx=tx;
	ev.ty=ty;
	ev.time=time;
	ev.started=false;
	ev.call=method(ev,function(){
		if(!instance_exists(inst))return;
		var dx=tx-inst.x;
		var dy=ty-inst.y;
		var dist=point_distance(0,0,dx,dy);
		if(dist<1){
			inst.x=tx;
			inst.y=ty;
			return;
		}

		var ang=point_direction(0,0,dx,dy);
		var d=DIR_CHAR.RIGHT;
		if(ang>=45&&ang<135)d=DIR_CHAR.UP;
		else if(ang>=135&&ang<225)d=DIR_CHAR.LEFT;
		else if(ang>=225&&ang<315)d=DIR_CHAR.DOWN;

		var dur=time;
		if(is_undefined(dur)||dur<=0){
			var spd=1;
			if(variable_instance_exists(inst,"move_speed"))spd=max(1,inst.move_speed[d]);
			dur=max(1,ceil(dist/spd));
		}

		inst.dir=d;
		inst.move[DIR_CHAR.UP]=0;
		inst.move[DIR_CHAR.DOWN]=0;
		inst.move[DIR_CHAR.LEFT]=0;
		inst.move[DIR_CHAR.RIGHT]=0;

		if(variable_instance_exists(inst,"res_override")){
			inst.res_override=true;
			if(variable_instance_exists(inst,"res_move_sprite")){
				inst.sprite_index=inst.res_move_sprite[d];
				inst.image_index=inst.res_move_image[d];
				inst.image_speed=max(0.5,inst.res_move_speed[d]);
			}
		}

		Anim_Destroy(inst,"x");
		Anim_Destroy(inst,"y");
		if(dx!=0)Anim_Create(inst,"x",ANIM_TWEEN.LINEAR,ANIM_EASE.IN,inst.x,dx,dur);
		if(dy!=0)Anim_Create(inst,"y",ANIM_TWEEN.LINEAR,ANIM_EASE.IN,inst.y,dy,dur);
		started=true;
	});
	ev.resume=method(ev,function(){
		if(!instance_exists(inst))return true;
		if(!started)return true;
		if(Anim_IsExists(inst,"x")||Anim_IsExists(inst,"y"))return false;
		inst.x=tx;
		inst.y=ty;
		if(variable_instance_exists(inst,"res_override")){
			inst.res_override=false;
			inst._dir_previous=-1;
		}
		started=false;
		return true;
	});
	ev.finish=method(ev,function(){
		if(!instance_exists(inst))return;
		Anim_Destroy(inst,"x");
		Anim_Destroy(inst,"y");
		if(variable_instance_exists(inst,"res_override")){
			inst.res_override=false;
			inst._dir_previous=-1;
		}
	});

	if(wait){
		cutscene_queue_event(global.current_cutscene,ev);
	}else{
		ev.resume=undefined;
		cutscene_queue_event(global.current_cutscene,ev);
	}
}

///@arg inst
///@arg var_name
///@arg tween
///@arg ease
///@arg start
///@arg change
///@arg duration
///@arg delay*  (default 0)
///@arg wait*   (default true)
function cutscene_anim(){
	var inst=argument[0];
	var var_name=argument[1];
	var tween=argument[2];
	var ease=argument[3];
	var start=argument[4];
	var change=argument[5];
	var duration=argument[6];
	var delay=0;
	var wait=true;
	if(argument_count>7)delay=argument[7];
	if(argument_count>8)wait=argument[8];
	if(wait){
		cutscene_queue_event(global.current_cutscene,cutscene_make_event(
			method({inst:inst,var_name:var_name,tween:tween,ease:ease,start:start,change:change,duration:duration,delay:delay},function(){
				if(instance_exists(inst)){
					Anim_Destroy(inst,var_name);
					Anim_Create(inst,var_name,tween,ease,start,change,duration,delay);
				}
			}),
			method({inst:inst,var_name:var_name},function(){
				if(!instance_exists(inst))return true;
				return !Anim_IsExists(inst,var_name);
			})
		));
	}else{
		cutscene_queue_event(global.current_cutscene,cutscene_make_event(
			method({inst:inst,var_name:var_name,tween:tween,ease:ease,start:start,change:change,duration:duration,delay:delay},function(){
				if(instance_exists(inst)){
					Anim_Destroy(inst,var_name);
					Anim_Create(inst,var_name,tween,ease,start,change,duration,delay);
				}
			})
		));
	}
}

///@arg from
///@arg to
///@arg time
///@arg color*  (optional fader.color)
///@arg wait*   (default true)
function cutscene_fade(){
	var from=argument[0];
	var to=argument[1];
	var time=argument[2];
	var col=undefined;
	var wait=true;
	if(argument_count>3){
		if(is_bool(argument[3]))wait=argument[3];
		else col=argument[3];
	}
	if(argument_count>4)wait=argument[4];
	if(wait){
		cutscene_queue_event(global.current_cutscene,cutscene_make_event(
			method({from:from,to:to,time:time,col:col},function(){
				if(instance_exists(fader)&&!is_undefined(col)){
					fader.color=col;
				}
				Fader_Fade(from,to,time);
			}),
			function(){
				if(!instance_exists(fader))return true;
				return !Anim_IsExists(fader,"alpha");
			}
		));
	}else{
		cutscene_queue_event(global.current_cutscene,cutscene_make_event(
			method({from:from,to:to,time:time,col:col},function(){
				if(instance_exists(fader)&&!is_undefined(col)){
					fader.color=col;
				}
				Fader_Fade(from,to,time);
			})
		));
	}
}

///@arg encounter_id
///@arg anim*       (default true)
///@arg exclamation* (default true)
function cutscene_encounter(){
	var encounter=argument[0];
	var anim=true;
	var exclam=true;
	if(argument_count>1)anim=argument[1];
	if(argument_count>2)exclam=argument[2];

	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({encounter:encounter,anim:anim,exclam:exclam},function(){
			Encounter_Start(encounter,anim,exclam);
		}),
		function(){
			return !instance_exists(encounter_anim);
		}
	));
}

///@arg sound
///@arg priority* (default false)
///@arg loop*     (default false)
///@arg wait*     (default false; wait=true forces loop false)
function cutscene_sfx_play(){
	var sound=argument[0];
	var priority=false;
	var loop=false;
	var wait=false;
	if(argument_count>1)priority=argument[1];
	if(argument_count>2)loop=argument[2];
	if(argument_count>3)wait=argument[3];
	if(wait)loop=false;

	var ev=cutscene_make_event();
	ev.sound=sound;
	ev.priority=priority;
	ev.loop=loop;
	ev.audio_id=-1;
	ev.call=method(ev,function(){
		audio_id=SFX_Play(sound,priority,loop);
	});
	if(wait){
		ev.resume=method(ev,function(){
			if(audio_id<0)return true;
			return !audio_is_playing(audio_id);
		});
	}
	cutscene_queue_event(global.current_cutscene,ev);
}

///@arg audio_id
function cutscene_sfx_stop(){
	var audio_id=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({audio_id:audio_id},function(){
			SFX_Stop(audio_id);
		})
	));
}

///@arg slot
function cutscene_bgm_pause(){
	var slot=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({slot:slot},function(){
			BGM_Pause(slot);
		})
	));
}

///@arg slot
function cutscene_bgm_resume(){
	var slot=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({slot:slot},function(){
			BGM_Resume(slot);
		})
	));
}

///@arg slot
function cutscene_bgm_stop(){
	var slot=argument[0];
	cutscene_queue_event(global.current_cutscene,cutscene_make_event(
		method({slot:slot},function(){
			BGM_Stop(slot);
		})
	));
}
