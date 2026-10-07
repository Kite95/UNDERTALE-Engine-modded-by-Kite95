var inv=Item_GetInventoryItems();

if(_state==SHOP_STATE.MENU){
	if(_menu==SHOP_MENU.MENU){
		if(Input_IsPressed(INPUT.DOWN)){
			var n=_menu_choice;
			repeat(4){
				n=(n>2 ? 0 : n+1);
				if(Shop_GetMainLabel(n)!=""){
					if(n!=_menu_choice){
						_menu_choice=n;
						Shop_CallHostEvent(SHOP_HOST_EVENT.CHOICE_SWITCH);
					}
					break;
				}
			}
		}
		if(Input_IsPressed(INPUT.UP)){
			var n=_menu_choice;
			repeat(4){
				n=(n<1 ? 3 : n-1);
				if(Shop_GetMainLabel(n)!=""){
					if(n!=_menu_choice){
						_menu_choice=n;
						Shop_CallHostEvent(SHOP_HOST_EVENT.CHOICE_SWITCH);
					}
					break;
				}
			}
		}
		if(Input_IsPressed(INPUT.CONFIRM)&&Shop_GetMainLabel(_menu_choice)!=""){
			var act=Shop_GetMainAction(_menu_choice);
			switch(act){
				case SHOP_MAIN_ACTION.BUY:
					Shop_SetBuyFree(Shop_GetMainFree(_menu_choice));
					Shop_SetNextMenu(SHOP_MENU.BUY);
					Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
					Shop_SetState(SHOP_STATE.DIALOG);
					_dialog_pending=true;
					break;
				case SHOP_MAIN_ACTION.SELL:
					Shop_SetNextMenu(SHOP_MENU.SELL);
					Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
					Shop_SetState(SHOP_STATE.DIALOG);
					_dialog_pending=true;
					_sell_choice=0;
					_sell_thanks=0;
					break;
				case SHOP_MAIN_ACTION.TALK:
					Shop_SetNextMenu(SHOP_MENU.TALK);
					Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
					Shop_SetState(SHOP_STATE.DIALOG);
					_dialog_pending=true;
					break;
				case SHOP_MAIN_ACTION.DIALOG:
					//Show the slot text, then return to the main menu.
					var dd=Shop_GetMainDialog(_menu_choice);
					if(dd=="") break;
					Dialog_Add(dd);
					Shop_SetNextMenu(SHOP_MENU.MENU);
					Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
					Shop_SetState(SHOP_STATE.DIALOG);
					_dialog_pending=true;
					break;
				case SHOP_MAIN_ACTION.EXIT:
					Shop_SetNextMenu(SHOP_MENU.EXIT);
					Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
					Shop_SetState(SHOP_STATE.DIALOG);
					_dialog_pending=true;
					break;
			}
		}
	}

	if(_menu==SHOP_MENU.BUY){
		if(_menu_buy==SHOP_BUY.MENU){
			if(Input_IsPressed(INPUT.CANCEL)||(Input_IsPressed(INPUT.CONFIRM)&&_buy_choice==4)){
				Shop_SetNextMenu(SHOP_MENU.MENU);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
				_menu_buy=-1;
			}else{
				var buy_shown=Shop_GetListShown(Shop_GetBuyNumber());
				var buy_choice_was=_buy_choice;
				var buy_page_was=_page_buy;
				//VERTICAL steps. PAGE steps and turns pages.
				if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
					if(buy_shown<=0){
						_buy_choice=4;
						_page_buy=0;
					}else{
						var buy_slot=_page_buy;
						var buy_exit=(_buy_choice==4);
						if(!buy_exit)buy_slot=_page_buy+_buy_choice;
						if(Input_IsPressed(INPUT.DOWN)){
							if(!buy_exit){
								if(buy_slot+1<buy_shown)buy_slot+=1;
								else buy_exit=true;
							}
						}
						if(Input_IsPressed(INPUT.UP)){
							if(buy_exit){
								buy_slot=buy_shown-1;
								buy_exit=false;
							}else if(buy_slot>0){
								buy_slot-=1;
							}
						}
						if(buy_exit){
							_buy_choice=4;
							_page_buy=max(0,buy_shown-4);
						}else{
							var buy_first=_page_buy;
							if(buy_slot>=buy_first+4)buy_first=buy_slot-3;
							else if(buy_slot<buy_first)buy_first=buy_slot;
							var buy_first_max=max(0,buy_shown-4);
							if(buy_first<0)buy_first=0;
							if(buy_first>buy_first_max)buy_first=buy_first_max;
							_page_buy=buy_first;
							_buy_choice=buy_slot-buy_first;
						}
					}
					if(_page_buy!=buy_page_was){
						Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
					}
				}else{
					_buy_choice=Shop_StepPageChoice(_buy_choice,buy_shown,_page_buy);
					if(_buy_choice<4&&Shop_GetBuyPageMax()>1){
						_buy_choice=Shop_TurnListPage(_page_buy,_buy_choice,buy_shown);
						if(_page_buy!=buy_page_was){
							Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
						}
					}
				}
				if(_buy_choice!=buy_choice_was||_page_buy!=buy_page_was){
					_itemdesc_dialog="";
					Shop_CallHostEvent(SHOP_HOST_EVENT.CHOICE_SWITCH);
				}
				if(_buy_choice<4){
					if(Input_IsPressed(INPUT.CONFIRM)){
						var bidx=Shop_GetBuyChoice();
						if(Shop_IsSlotOpen(bidx)){
							Shop_SetMenuBuy(SHOP_BUY.CONFIRM);
						}else if(Shop_GetSlotState(bidx)==SHOP_SLOT.LOCKED){
							Shop_SetBuyResult(SHOP_BUY_RESULT.UNABLE);
							Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
							Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_START);
						}else if(Shop_GetSlotState(bidx)==SHOP_SLOT.SOLD_OUT){
							Shop_SetBuyResult(SHOP_BUY_RESULT.SOLD_OUT);
							Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
							Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_START);
						}
					}
				}
			}
		}else if(_menu_buy==SHOP_BUY.CONFIRM){
			if(Input_IsPressed(INPUT.CANCEL)){
				Shop_SetBuyResult(SHOP_BUY_RESULT.NO);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_SetMenu(SHOP_MENU.BUY);
				Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
				Shop_ClearTextTyperChoice();
			}else if(Player_GetTextTyperChoice()==0){
				Shop_SetBuyResult(Shop_TryBuy(Shop_GetBuyChoice()));
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_SetMenu(SHOP_MENU.BUY);
				Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
				Shop_ClearTextTyperChoice();
			}else if(Player_GetTextTyperChoice()==1){
				Shop_SetBuyResult(SHOP_BUY_RESULT.NO);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_SetMenu(SHOP_MENU.BUY);
				Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
				Shop_ClearTextTyperChoice();
			}
		}
	}

	if(_menu==SHOP_MENU.SELL){
		if(_menu_sell==SHOP_SELL.MENU){
			var count=inv.GetCount();
			if(count==0){
				_sell_choice=8;
			}else{
				if(Input_IsPressed(INPUT.DOWN)){
					_sell_choice=(_sell_choice>7 ? _sell_choice mod 2 : _sell_choice+2);
					if(_sell_choice mod 2==0){
						if(_sell_choice==(count+1) div 2*2)_sell_choice=8;
					}else{
						if(_sell_choice==count div 2*2+1)_sell_choice=1;
					}
				}
				if(Input_IsPressed(INPUT.UP)){
					if(_sell_choice==8){
						_sell_choice=(((count+1) div 2)-1)*2;
					}else{
						_sell_choice-=2;
						if(_sell_choice==-2)_sell_choice=8;
						else if(_sell_choice==-1)_sell_choice=count div 2*2-1;
					}
				}
				if(Input_IsPressed(INPUT.RIGHT)||Input_IsPressed(INPUT.LEFT)){
					if(_sell_choice!=8){
						if(count mod 2==0||!(count mod 2==1&&_sell_choice==count-1)){
							_sell_choice=(_sell_choice mod 2 ? _sell_choice-1 : _sell_choice+1);
						}
					}
				}
			}
			if(Input_IsPressed(INPUT.CONFIRM)&&_sell_choice<8){
				if(_sell_choice<count&&Shop_GetItemSellPrice(inv.Get(_sell_choice))>0){
					Shop_SetMenuSell(SHOP_SELL.CONFIRM);
				}
				//Unsellable: ignore.
			}
			if(Input_IsPressed(INPUT.CANCEL)||(Input_IsPressed(INPUT.CONFIRM)&&_sell_choice==8)){
				Shop_SetNextMenu(SHOP_MENU.MENU);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
				_menu_sell=-1;
			}
		}else if(_menu_sell==SHOP_SELL.CONFIRM){
			if(Input_IsPressed(INPUT.CANCEL)){
				Shop_SetSellResult(SHOP_SELL_RESULT.NO);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_ClearTextTyperChoice();
				Shop_SetNextMenu(SHOP_MENU.SELL);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
			}else if(Player_GetTextTyperChoice()==0){
				var sell_result=Shop_TrySell(_sell_choice);
				Shop_SetSellResult(sell_result);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_ClearTextTyperChoice();
				if(sell_result==SHOP_SELL_RESULT.YES)_sell_choice=0;
				Shop_SetNextMenu(SHOP_MENU.SELL);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
			}else if(Player_GetTextTyperChoice()==1){
				Shop_SetSellResult(SHOP_SELL_RESULT.NO);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_ClearTextTyperChoice();
				Shop_SetNextMenu(SHOP_MENU.SELL);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
			}
		}
	}

	if(_menu==SHOP_MENU.TALK){
		if(Input_IsPressed(INPUT.CANCEL)||(Input_IsPressed(INPUT.CONFIRM)&&_talk_choice==4)){
			Shop_SetNextMenu(SHOP_MENU.MENU);
			Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
			Shop_SetState(SHOP_STATE.DIALOG);
			_dialog_pending=true;
		}else{
			var talk_shown=Shop_GetListShown(Shop_GetTalkNumber());
			var talk_choice_was=_talk_choice;
			var talk_page_was=_page_talk;
			//VERTICAL steps. PAGE steps and turns pages.
			if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
				if(talk_shown<=0){
					_talk_choice=4;
					_page_talk=0;
				}else{
					var talk_slot=_page_talk;
					var talk_exit=(_talk_choice==4);
					if(!talk_exit)talk_slot=_page_talk+_talk_choice;
					if(Input_IsPressed(INPUT.DOWN)){
						if(!talk_exit){
							if(talk_slot+1<talk_shown)talk_slot+=1;
							else talk_exit=true;
						}
					}
					if(Input_IsPressed(INPUT.UP)){
						if(talk_exit){
							talk_slot=talk_shown-1;
							talk_exit=false;
						}else if(talk_slot>0){
							talk_slot-=1;
						}
					}
					if(talk_exit){
						_talk_choice=4;
						_page_talk=max(0,talk_shown-4);
					}else{
						var talk_first=_page_talk;
						if(talk_slot>=talk_first+4)talk_first=talk_slot-3;
						else if(talk_slot<talk_first)talk_first=talk_slot;
						var talk_first_max=max(0,talk_shown-4);
						if(talk_first<0)talk_first=0;
						if(talk_first>talk_first_max)talk_first=talk_first_max;
						_page_talk=talk_first;
						_talk_choice=talk_slot-talk_first;
					}
				}
				if(_page_talk!=talk_page_was){
					Shop_SetMenuTalk(_page_talk);
				}
			}else{
				_talk_choice=Shop_StepPageChoice(_talk_choice,talk_shown,_page_talk);
				if(_talk_choice<4&&Shop_GetTalkPageMax()>1){
					_talk_choice=Shop_TurnListPage(_page_talk,_talk_choice,talk_shown);
					if(_page_talk!=talk_page_was){
						Shop_SetMenuTalk(_page_talk);
					}
				}
			}
			if(_talk_choice!=talk_choice_was||_page_talk!=talk_page_was){
				Shop_CallHostEvent(SHOP_HOST_EVENT.CHOICE_SWITCH);
			}
			if(Input_IsPressed(INPUT.CONFIRM)&&_talk_choice<4){
				var tidx=Shop_GetTalkChoice();
				var td=Shop_GetTalkDialog(tidx);
				if(td!="")Dialog_Add(td);
				Shop_AdvanceTalk(tidx);
				Shop_SetNextMenu(SHOP_MENU.TALK);
				Shop_SetState(SHOP_STATE.DIALOG);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				_dialog_pending=true;
			}
		}
	}

	if(_menu==SHOP_MENU.EXIT){
		if(fader.alpha>=1){
			Fader_Fade(1,0,20);
			BGM_Stop(4);
			var room_return=Storage_GetTempGeneral().Get(FLAG_TEMP_SHOP_ROOM_RETURN,-1);
			if(room_exists(room_return))room_goto(room_return);
		}
	}
}else if(_state==SHOP_STATE.DIALOG){
	if(_dialog_pending){
		_dialog_pending=false;
		Shop_ClearUITypers();
		if(!Dialog_IsEmpty()){
			Shop_CallHostEvent(SHOP_HOST_EVENT.DIALOG_START);
			Shop_SetDialog(Dialog_Get()+"{pause}{end}");
		}else if(Shop_IsDialogAutoEnd()){
			Shop_EndDialog();
		}
	}else if(!instance_exists(_inst_dialog[0])){
		if(!Dialog_IsEmpty()){
			Shop_CallHostEvent(SHOP_HOST_EVENT.DIALOG_START);
			Shop_SetDialog(Dialog_Get()+"{pause}{end}");
		}else if(Shop_IsDialogAutoEnd()){
			Shop_EndDialog();
		}
	}
}
