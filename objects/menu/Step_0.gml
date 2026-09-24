if(_menu==0){
	if(_mode==2){
		if(_hint_timer>0){
			_hint_timer-=1;
			if(_hint_timer<=0){
				if(instance_exists(_inst_title)&&_hint_title!=""){
					Typer_SetText(_inst_title,_prefix_outline+_hint_title);
				}
				_hint_title="";
			}
		}
		if(_file_action==3||_file_action==5||_file_action==6){
			if(Input_IsPressed(INPUT.LEFT)){
				if(_choice_file==1){
					_choice_file=0;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.RIGHT)){
				if(_choice_file==0){
					_choice_file=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.CONFIRM)||Input_IsPressed(INPUT.CANCEL)){
				var cancel=Input_IsPressed(INPUT.CANCEL);
				if(cancel){
					SFX_Play(snd_menu_cancel,0,false);
					_choice_file=1;
				}
				if(_file_action==3){
					if(_choice_file==0){
						Storage_CopySlot(_copy_from,_copy_to);
						SFX_Play(snd_menu_confirm,0,false);
						_choice_restore=_copy_to;
						event_user(0);
						if(_mode==2){
							if(instance_exists(_inst_title)){
								Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.done","The file was copied."));
							}
							_hint_title=Lang_GetString("menu.file_select","File Select");
							_hint_timer=90;
						}
					}else{
						if(!cancel){
							SFX_Play(snd_menu_cancel,0,false);
						}
						var sid=_copy_to;
						if(instance_exists(_inst_slot_name[sid])){
							instance_destroy(_inst_slot_name[sid]);
						}
						if(instance_exists(_inst_slot_lv[sid])){
							instance_destroy(_inst_slot_lv[sid]);
						}
						if(instance_exists(_inst_slot_time[sid])){
							instance_destroy(_inst_slot_time[sid]);
						}
						if(instance_exists(_inst_slot_room[sid])){
							instance_destroy(_inst_slot_room[sid]);
						}
						if(instance_exists(_inst_slot_continue)){
							instance_destroy(_inst_slot_continue);
						}
						if(instance_exists(_inst_slot_reset)){
							instance_destroy(_inst_slot_reset);
						}
						_inst_slot_continue=noone;
						_inst_slot_reset=noone;
						var peek=_slot_peek[sid];
						if(!is_struct(peek)){
							_inst_slot_name[sid]=instance_create_depth(160,105+sid*92,0,text_typer);
							_inst_slot_name[sid].text=_prefix+Lang_GetString("menu.file.empty","[EMPTY]");
							_inst_slot_lv[sid]=instance_create_depth(280,105+sid*92,0,text_typer);
							_inst_slot_lv[sid].text=_prefix+Lang_GetString("menu.file.empty","[EMPTY]");
							_inst_slot_time[sid]=instance_create_depth(408,105+sid*92,0,text_typer);
							_inst_slot_time[sid].text=_prefix+Lang_GetString("menu.file.time.empty","--:--");
							_inst_slot_room[sid]=instance_create_depth(160,139+sid*92,0,text_typer);
							_inst_slot_room[sid].text=_prefix+Lang_GetString("menu.file.room.empty","---------");
						}else{
							var minute=floor(peek.time/60);
							var second=peek.time%60;
							_inst_slot_name[sid]=instance_create_depth(160,105+sid*92,0,text_typer);
							_inst_slot_name[sid].text=_prefix+string(peek.name);
							_inst_slot_lv[sid]=instance_create_depth(280,105+sid*92,0,text_typer);
							_inst_slot_lv[sid].text=_prefix+"LV "+string(peek.lv);
							_inst_slot_time[sid]=instance_create_depth(408,105+sid*92,0,text_typer);
							_inst_slot_time[sid].text=_prefix+string(minute)+":"+(second<10 ? "0" : "")+string(second);
							_inst_slot_room[sid]=instance_create_depth(160,139+sid*92,0,text_typer);
							_inst_slot_room[sid].text=_prefix+Player_GetRoomName(asset_get_index(peek.room));
						}
						_inst_slot_name[sid].override_color_text_enabled=true;
						_inst_slot_lv[sid].override_color_text_enabled=true;
						_inst_slot_time[sid].override_color_text_enabled=true;
						_inst_slot_room[sid].override_color_text_enabled=true;
						_file_action=2;
						_choice=_copy_to;
						_choice_file=0;
						event_user(2);
					}
				}else if(_file_action==5){
					if(_choice_file==0){
						SFX_Play(snd_menu_confirm,0,false);
						_file_action=6;
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.warn","Then it will be destroyed."));
						}
						var sid=_erase_slot;
						if(instance_exists(_inst_slot_name[sid])){
							Typer_SetText(_inst_slot_name[sid],_prefix+Lang_GetString("menu.erase.really","Really erase it?"));
							_inst_slot_name[sid].override_color_text_enabled=true;
						}
						if(instance_exists(_inst_slot_continue)){
							Typer_SetText(_inst_slot_continue,_prefix+Lang_GetString("menu.yes_bang","Yes!"));
							_inst_slot_continue.override_color_text_enabled=true;
						}
						if(instance_exists(_inst_slot_reset)){
							Typer_SetText(_inst_slot_reset,_prefix+Lang_GetString("menu.no_bang","No!"));
							_inst_slot_reset.override_color_text_enabled=true;
						}
						_choice_file=0;
						event_user(2);
					}else{
						if(!cancel){
							SFX_Play(snd_menu_cancel,0,false);
						}
						var sid=_erase_slot;
						if(instance_exists(_inst_slot_name[sid])){
							instance_destroy(_inst_slot_name[sid]);
						}
						if(instance_exists(_inst_slot_lv[sid])){
							instance_destroy(_inst_slot_lv[sid]);
						}
						if(instance_exists(_inst_slot_time[sid])){
							instance_destroy(_inst_slot_time[sid]);
						}
						if(instance_exists(_inst_slot_room[sid])){
							instance_destroy(_inst_slot_room[sid]);
						}
						if(instance_exists(_inst_slot_continue)){
							instance_destroy(_inst_slot_continue);
						}
						if(instance_exists(_inst_slot_reset)){
							instance_destroy(_inst_slot_reset);
						}
						_inst_slot_continue=noone;
						_inst_slot_reset=noone;
						var peek=_slot_peek[sid];
						if(!is_struct(peek)){
							_inst_slot_name[sid]=instance_create_depth(160,105+sid*92,0,text_typer);
							_inst_slot_name[sid].text=_prefix+Lang_GetString("menu.file.empty","[EMPTY]");
							_inst_slot_lv[sid]=instance_create_depth(280,105+sid*92,0,text_typer);
							_inst_slot_lv[sid].text=_prefix+Lang_GetString("menu.file.empty","[EMPTY]");
							_inst_slot_time[sid]=instance_create_depth(408,105+sid*92,0,text_typer);
							_inst_slot_time[sid].text=_prefix+Lang_GetString("menu.file.time.empty","--:--");
							_inst_slot_room[sid]=instance_create_depth(160,139+sid*92,0,text_typer);
							_inst_slot_room[sid].text=_prefix+Lang_GetString("menu.file.room.empty","---------");
						}else{
							var minute=floor(peek.time/60);
							var second=peek.time%60;
							_inst_slot_name[sid]=instance_create_depth(160,105+sid*92,0,text_typer);
							_inst_slot_name[sid].text=_prefix+string(peek.name);
							_inst_slot_lv[sid]=instance_create_depth(280,105+sid*92,0,text_typer);
							_inst_slot_lv[sid].text=_prefix+"LV "+string(peek.lv);
							_inst_slot_time[sid]=instance_create_depth(408,105+sid*92,0,text_typer);
							_inst_slot_time[sid].text=_prefix+string(minute)+":"+(second<10 ? "0" : "")+string(second);
							_inst_slot_room[sid]=instance_create_depth(160,139+sid*92,0,text_typer);
							_inst_slot_room[sid].text=_prefix+Player_GetRoomName(asset_get_index(peek.room));
						}
						_inst_slot_name[sid].override_color_text_enabled=true;
						_inst_slot_lv[sid].override_color_text_enabled=true;
						_inst_slot_time[sid].override_color_text_enabled=true;
						_inst_slot_room[sid].override_color_text_enabled=true;
						_file_action=4;
						_choice=_erase_slot;
						_choice_file=0;
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.choose","Select the one to erase"));
						}
						event_user(2);
					}
				}else if(_file_action==6){
					if(_choice_file==0){
						Storage_EraseSlot(_erase_slot);
						SFX_Play(snd_menu_confirm,0,false);
						_choice_restore=_erase_slot;
						event_user(0);
						if(_mode==2){
							if(instance_exists(_inst_title)){
								Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.done","The file was erased."));
							}
							_hint_title=Lang_GetString("menu.file_select","File Select");
							_hint_timer=90;
						}
					}else{
						if(!cancel){
							SFX_Play(snd_menu_cancel,0,false);
						}
						_file_action=5;
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.choose","Select the one to erase"));
						}
						var sid=_erase_slot;
						if(instance_exists(_inst_slot_name[sid])){
							Typer_SetText(_inst_slot_name[sid],_prefix+Lang_GetString("menu.erase.confirm","Erase this file?"));
							_inst_slot_name[sid].override_color_text_enabled=true;
						}
						if(instance_exists(_inst_slot_continue)){
							Typer_SetText(_inst_slot_continue,_prefix+Lang_GetString("menu.yes"));
							_inst_slot_continue.override_color_text_enabled=true;
						}
						if(instance_exists(_inst_slot_reset)){
							Typer_SetText(_inst_slot_reset,_prefix+Lang_GetString("menu.no"));
							_inst_slot_reset.override_color_text_enabled=true;
						}
						_choice_file=0;
						event_user(2);
					}
				}
			}
		}else if(_file_action==1||_file_action==2||_file_action==4){
			if(Input_IsPressed(INPUT.UP)){
				if(_choice>0&&_choice<=2){
					_choice-=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice>=3){
					_choice=2;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.DOWN)){
				if(_choice<2){
					_choice+=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice==2){
					_choice=3;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.CONFIRM)){
				if(_choice>=3){
					SFX_Play(snd_menu_cancel,0,false);
					event_user(0);
				}else if(_file_action==1){
					if(!is_struct(_slot_peek[_choice])){
						SFX_Play(snd_menu_confirm,0,false);
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.empty","It can't be copied."));
						}
						_hint_title=Lang_GetString("menu.copy.choose","Choose the one to copy");
						_hint_timer=90;
					}else{
						SFX_Play(snd_menu_confirm,0,false);
						_copy_from=_choice;
						_file_action=2;
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.target","Choose the target for the reflection"));
						}
						event_user(2);
					}
				}else if(_file_action==2){
					if(_choice==_copy_from){
						SFX_Play(snd_menu_confirm,0,false);
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.same","You cannot copy a file over itself."));
						}
						_hint_title=Lang_GetString("menu.copy.target","Choose the target for the reflection");
						_hint_timer=90;
					}else{
						_copy_to=_choice;
						if(!is_struct(_slot_peek[_copy_to])){
							Storage_CopySlot(_copy_from,_copy_to);
							SFX_Play(snd_menu_confirm,0,false);
							_choice_restore=_copy_to;
							event_user(0);
							if(_mode==2){
								if(instance_exists(_inst_title)){
									Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.done","The file was copied."));
								}
								_hint_title=Lang_GetString("menu.file_select","File Select");
								_hint_timer=90;
							}
						}else{
							SFX_Play(snd_menu_confirm,0,false);
							_file_action=3;
							var sid=_copy_to;
							if(instance_exists(_inst_slot_lv[sid])){
								instance_destroy(_inst_slot_lv[sid]);
							}
							if(instance_exists(_inst_slot_time[sid])){
								instance_destroy(_inst_slot_time[sid]);
							}
							if(instance_exists(_inst_slot_room[sid])){
								instance_destroy(_inst_slot_room[sid]);
							}
							_inst_slot_lv[sid]=noone;
							_inst_slot_time[sid]=noone;
							_inst_slot_room[sid]=noone;
							if(instance_exists(_inst_slot_name[sid])){
								Typer_SetText(_inst_slot_name[sid],_prefix+Lang_GetString("menu.copy.confirm","Copy over this file?"));
								_inst_slot_name[sid].override_color_text_enabled=true;
							}
							if(instance_exists(_inst_slot_continue)){
								instance_destroy(_inst_slot_continue);
							}
							if(instance_exists(_inst_slot_reset)){
								instance_destroy(_inst_slot_reset);
							}
							_inst_slot_continue=instance_create_depth(160,139+sid*92,0,text_typer);
							_inst_slot_continue.text=_prefix+Lang_GetString("menu.yes");
							_inst_slot_continue.override_color_text_enabled=true;
							_inst_slot_reset=instance_create_depth(360,139+sid*92,0,text_typer);
							_inst_slot_reset.text=_prefix+Lang_GetString("menu.no");
							_inst_slot_reset.override_color_text_enabled=true;
							_choice_file=0;
							event_user(2);
						}
					}
				}else if(_file_action==4){
					if(!is_struct(_slot_peek[_choice])){
						SFX_Play(snd_menu_confirm,0,false);
						if(instance_exists(_inst_title)){
							Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.empty","There's nothing to erase."));
						}
						_hint_title=Lang_GetString("menu.erase.choose","Select the one to erase");
						_hint_timer=90;
					}else{
						SFX_Play(snd_menu_confirm,0,false);
						_erase_slot=_choice;
						_file_action=5;
						var sid=_erase_slot;
						if(instance_exists(_inst_slot_lv[sid])){
							instance_destroy(_inst_slot_lv[sid]);
						}
						if(instance_exists(_inst_slot_time[sid])){
							instance_destroy(_inst_slot_time[sid]);
						}
						if(instance_exists(_inst_slot_room[sid])){
							instance_destroy(_inst_slot_room[sid]);
						}
						_inst_slot_lv[sid]=noone;
						_inst_slot_time[sid]=noone;
						_inst_slot_room[sid]=noone;
						if(instance_exists(_inst_slot_name[sid])){
							Typer_SetText(_inst_slot_name[sid],_prefix+Lang_GetString("menu.erase.confirm","Erase this file?"));
							_inst_slot_name[sid].override_color_text_enabled=true;
						}
						if(instance_exists(_inst_slot_continue)){
							instance_destroy(_inst_slot_continue);
						}
						if(instance_exists(_inst_slot_reset)){
							instance_destroy(_inst_slot_reset);
						}
						_inst_slot_continue=instance_create_depth(160,139+sid*92,0,text_typer);
						_inst_slot_continue.text=_prefix+Lang_GetString("menu.yes");
						_inst_slot_continue.override_color_text_enabled=true;
						_inst_slot_reset=instance_create_depth(360,139+sid*92,0,text_typer);
						_inst_slot_reset.text=_prefix+Lang_GetString("menu.no");
						_inst_slot_reset.override_color_text_enabled=true;
						_choice_file=0;
						event_user(2);
					}
				}
			}else if(Input_IsPressed(INPUT.CANCEL)){
				SFX_Play(snd_menu_cancel,0,false);
				if(_file_action==2){
					_file_action=1;
					_copy_from=-1;
					if(instance_exists(_inst_title)){
						Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.choose","Choose the one to copy"));
					}
					event_user(2);
				}else{
					event_user(0);
				}
			}
		}else if(_slot_open){
			if(Input_IsPressed(INPUT.LEFT)){
				if(_choice_file==1){
					_choice_file=0;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.RIGHT)){
				if(_choice_file==0){
					_choice_file=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.CONFIRM)){
				if(_choice_file==0){
					SFX_Play(snd_menu_confirm,0,false);
					_slot_choice=_choice;
					Storage_SetSlot(_choice);
					if(is_struct(_slot_peek[_choice])){
						Storage_Load(_choice);
						var roomName=Storage_GetStaticGeneral().Get(FLAG_STATIC_ROOM,"");
						var roomIndex=asset_get_index(roomName);
						if(!room_exists(roomIndex)){
							roomIndex=-1;
						}
						if(room_exists(roomIndex)){
							room_goto(roomIndex);
						}else{
							show_message("ERROR:\nAttempt to goto an unexisting room "+string(roomName));
						}
					}else{
						_naming_name="";
						_mode=0;
						_menu=1;
						event_user(0);
					}
				}else if(is_struct(_slot_peek[_choice])){
					SFX_Play(snd_menu_confirm,0,false);
					_slot_choice=_choice;
					Storage_SetSlot(_choice);
					_naming_name=_slot_peek[_choice].name;
					_confirm_title=Lang_GetString("menu.confirm.title.reset");
					_mode=1;
					_menu=2;
					event_user(0);
				}else{
					SFX_Play(snd_menu_cancel,0,false);
					if(instance_exists(_inst_slot_continue)){
						instance_destroy(_inst_slot_continue);
					}
					if(instance_exists(_inst_slot_reset)){
						instance_destroy(_inst_slot_reset);
					}
					_inst_slot_continue=noone;
					_inst_slot_reset=noone;
					_inst_slot_room[_choice]=instance_create_depth(160,139+_choice*92,0,text_typer);
					_inst_slot_room[_choice].text=_prefix+Lang_GetString("menu.file.room.empty","---------");
					_inst_slot_room[_choice].override_color_text_enabled=true;
					_slot_open=false;
					_choice_file=0;
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.CANCEL)){
				SFX_Play(snd_menu_cancel,0,false);
				if(instance_exists(_inst_slot_continue)){
					instance_destroy(_inst_slot_continue);
				}
				if(instance_exists(_inst_slot_reset)){
					instance_destroy(_inst_slot_reset);
				}
				_inst_slot_continue=noone;
				_inst_slot_reset=noone;
				var peek=_slot_peek[_choice];
				_inst_slot_room[_choice]=instance_create_depth(160,139+_choice*92,0,text_typer);
				if(!is_struct(peek)){
					_inst_slot_room[_choice].text=_prefix+Lang_GetString("menu.file.room.empty","---------");
				}else{
					_inst_slot_room[_choice].text=_prefix+Player_GetRoomName(asset_get_index(peek.room));
				}
				_inst_slot_room[_choice].override_color_text_enabled=true;
				_slot_open=false;
				_choice_file=0;
				event_user(2);
			}
		}else{
			if(Input_IsPressed(INPUT.UP)){
				if(_choice>0&&_choice<=2){
					_choice-=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice>=3){
					_choice=2;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.DOWN)){
				if(_choice<2){
					_choice+=1;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice==2){
					_choice=3;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.LEFT)){
				if(_choice==4){
					_choice=3;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice==5){
					_choice=4;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.RIGHT)){
				if(_choice==3){
					_choice=4;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}else if(_choice==4){
					_choice=5;
					SFX_Play(snd_menu_switch,0,false);
					event_user(2);
				}
			}else if(Input_IsPressed(INPUT.CONFIRM)){
				SFX_Play(snd_menu_confirm,0,false);
				if(_choice<3){
					if(instance_exists(_inst_slot_room[_choice])){
						instance_destroy(_inst_slot_room[_choice]);
					}
					_inst_slot_room[_choice]=noone;
					var empty=!is_struct(_slot_peek[_choice]);
					_inst_slot_continue=instance_create_depth(160,139+_choice*92,0,text_typer);
					_inst_slot_reset=instance_create_depth(360,139+_choice*92,0,text_typer);
					if(empty){
						_inst_slot_continue.text=_prefix+Lang_GetString("menu.start","Start");
						_inst_slot_reset.text=_prefix+Lang_GetString("menu.back","Back");
					}else{
						_inst_slot_continue.text=_prefix+Lang_GetString("menu.continue");
						_inst_slot_reset.text=_prefix+Lang_GetString("menu.reset");
					}
					_inst_slot_continue.override_color_text_enabled=true;
					_inst_slot_reset.override_color_text_enabled=true;
					_slot_open=true;
					_choice_file=0;
					event_user(2);
				}else if(_choice==3){
					_file_action=1;
					_choice=0;
					if(instance_exists(_inst_erase)){
						instance_destroy(_inst_erase);
					}
					if(instance_exists(_inst_settings)){
						instance_destroy(_inst_settings);
					}
					_inst_erase=noone;
					_inst_settings=noone;
					if(instance_exists(_inst_copy)){
						Typer_SetText(_inst_copy,_prefix_outline+Lang_GetString("menu.cancel","Cancel"));
						_inst_copy.override_color_text_enabled=true;
					}
					if(instance_exists(_inst_title)){
						Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.copy.choose","Choose the one to copy"));
					}
					event_user(2);
				}else if(_choice==4){
					_file_action=4;
					_choice=0;
					if(instance_exists(_inst_erase)){
						instance_destroy(_inst_erase);
					}
					if(instance_exists(_inst_settings)){
						instance_destroy(_inst_settings);
					}
					_inst_erase=noone;
					_inst_settings=noone;
					if(instance_exists(_inst_copy)){
						Typer_SetText(_inst_copy,_prefix_outline+Lang_GetString("menu.cancel","Cancel"));
						_inst_copy.override_color_text_enabled=true;
					}
					if(instance_exists(_inst_title)){
						Typer_SetText(_inst_title,_prefix_outline+Lang_GetString("menu.erase.choose","Select the one to erase"));
					}
					event_user(2);
				}else if(_choice==5){
					room_goto(room_settings);
				}
			}
		}
	}else if(_mode==0){
		if(Input_IsPressed(INPUT.DOWN)){
			if(_choice<1){
				_choice=1;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.UP)){
			if(_choice>0){
				_choice=0;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.CONFIRM)){
			if(_choice==0){
				_slot_choice=0;
				Storage_SetSlot(0);
				_menu=1;
				event_user(0);
			}else{
				room_goto(room_settings);
			}
		}
	}else{
		if(Input_IsPressed(INPUT.LEFT)){
			if(_choice==1){
				_choice=0;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.RIGHT)){
			if(_choice==0){
				_choice=1;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.DOWN)){
			if(_choice!=2){
				_choice=2;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.UP)){
			if(_choice==2){
				_choice=0;
				event_user(2);
			}
		}else if(Input_IsPressed(INPUT.CONFIRM)){
			if(_choice==0){
				Storage_Load(Storage_GetSlot());
				var roomName=Storage_GetStaticGeneral().Get(FLAG_STATIC_ROOM,"");
				var roomIndex=asset_get_index(roomName);
				if(!room_exists(roomIndex)){
					roomIndex=-1;
				}
				if(room_exists(roomIndex)){
					room_goto(roomIndex);
				}else{
					show_message("ERROR:\nAttempt to goto an unexisting room "+string(roomName));
				}
			}else if(_choice==1){
				_menu=2;
				var z=Storage_GetInfoGeneral();
				_naming_name=z.Get(FLAG_INFO_NAME,"???");
				_confirm_title=Lang_GetString("menu.confirm.title.reset");
				event_user(0);
			}else if(_choice==2){
				room_goto(room_settings);
			}
		}
	}
}else if(_menu==1){
	if(_choice_naming==0){
		if(Input_IsPressed(INPUT.RIGHT)){
			if(_choice_naming_letter<51){
				_choice_naming_letter+=1;
				event_user(3);
			}
		}else if(Input_IsPressed(INPUT.LEFT)){
			if(_choice_naming_letter>0){
				_choice_naming_letter-=1;
				event_user(3);
			}
		}else if(Input_IsPressed(INPUT.UP)){
			if(_choice_naming_letter>=0&&_choice_naming_letter<=1){
				_choice_naming=1;
				_choice_naming_command=0;
			}else if(_choice_naming_letter>=2&&_choice_naming_letter<=4){
				_choice_naming=1;
				_choice_naming_command=1;
			}else if(_choice_naming_letter>=5&&_choice_naming_letter<=6){
				_choice_naming=1;
				_choice_naming_command=2;
			}else if(_choice_naming_letter>=26&&_choice_naming_letter<=30){
				_choice_naming_letter-=5;
			}else if(_choice_naming_letter>=31&&_choice_naming_letter<=32){
				_choice_naming_letter-=12;
			}else{
				_choice_naming_letter-=7;
			}
			event_user(3);
		}else if(Input_IsPressed(INPUT.DOWN)){
			if(_choice_naming_letter>=21&&_choice_naming_letter<=25){
				_choice_naming_letter+=5;
			}else if(_choice_naming_letter>=19&&_choice_naming_letter<=20){
				_choice_naming_letter+=12;
			}else if(_choice_naming_letter>=45&&_choice_naming_letter<=46){
				_choice_naming=1;
				_choice_naming_command=2;
			}else if(_choice_naming_letter>=47&&_choice_naming_letter<=48){
				_choice_naming=1;
				_choice_naming_command=0;
			}else if(_choice_naming_letter>=49&&_choice_naming_letter<=51){
				_choice_naming=1;
				_choice_naming_command=1;
			}else{
				_choice_naming_letter+=7;
			}
			event_user(3);
		}else if(Input_IsPressed(INPUT.CONFIRM)){
			if(string_length(_naming_name)<6){
				var inst=_inst_naming_letters._list_inst[|_choice_naming_letter];
				_naming_name+=inst.text;
			}
		}else if(Input_IsPressed(INPUT.CANCEL)){
			if(string_length(_naming_name)>0){
				_naming_name=string_delete(_naming_name,string_length(_naming_name),1);
			}
		}
	}else{
		if(Input_IsPressed(INPUT.RIGHT)){
			if(_choice_naming_command<2){
				_choice_naming_command+=1;
				event_user(3);
			}
		}else if(Input_IsPressed(INPUT.LEFT)){
			if(_choice_naming_command>0){
				_choice_naming_command-=1;
				event_user(3);
			}
		}else if(Input_IsPressed(INPUT.UP)){
			if(_choice_naming_command==0){
				_choice_naming=0;
				_choice_naming_letter=47;
			}else if(_choice_naming_command==1){
				_choice_naming=0;
				_choice_naming_letter=49;
			}else if(_choice_naming_command==2){
				_choice_naming=0;
				_choice_naming_letter=45;
			}
			event_user(3);
		}else if(Input_IsPressed(INPUT.DOWN)){
			if(_choice_naming_command==0){
				_choice_naming=0;
				_choice_naming_letter=0;
			}else if(_choice_naming_command==1){
				_choice_naming=0;
				_choice_naming_letter=2;
			}else if(_choice_naming_command==2){
				_choice_naming=0;
				_choice_naming_letter=5;
			}
			event_user(3);
		}else if(Input_IsPressed(INPUT.CONFIRM)){
			if(_choice_naming_command==0){
				_menu=0;
				event_user(0);
			}
			if(_choice_naming_command==1){
				if(string_length(_naming_name)>0){
					_naming_name=string_delete(_naming_name,string_length(_naming_name),1);
				}
			}
			if(_choice_naming_command==2){
				if(_naming_name!=""){
					event_user(4);
					_menu=2;
					event_user(0);
				}
			}
		}else if(Input_IsPressed(INPUT.CANCEL)){
			if(string_length(_naming_name)>0){
				_naming_name=string_delete(_naming_name,string_length(_naming_name),1);
			}
		}
	}
}else if(_menu==2){
	if(Input_IsPressed(INPUT.LEFT)){
		if(_choice_confirm>0){
			_choice_confirm=0;
			event_user(5);
		}
	}else if(Input_IsPressed(INPUT.RIGHT)){
		if(_choice_confirm<1&&_confirm_valid){
			_choice_confirm=1;
			event_user(5);
		}
	}else if(Input_IsPressed(INPUT.CONFIRM)){
		if(_choice_confirm==0){
			_menu=(_mode==0 ? 1 : 0);
			event_user(0);
		}else{
			_menu=3;
			event_user(0);
		}
	}
}

if(_menu==2||_menu==3){
	if(_confirm_name_update){
		_confirm_name_offset_x=random_range(-1,1);
		_confirm_name_offset_y=random_range(-1,1);
		_confirm_name_angle=random_range(-1,1);
	}
	_confirm_name_update=!_confirm_name_update;
}