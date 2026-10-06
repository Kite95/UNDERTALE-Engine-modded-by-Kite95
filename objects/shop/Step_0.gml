var shop_state=Shop_GetState();
var shop_menu=Shop_GetMenu();
var shop_menu_buy=Shop_GetMenuBuy();
var shop_menu_sell=Shop_GetMenuSell();
var inv=Item_GetInventoryItems();

if(shop_state==SHOP_STATE.MENU){
	if(shop_menu==SHOP_MENU.MENU){
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
					// Same pattern as sell-empty refuse: text then back to main
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

	if(shop_menu==SHOP_MENU.BUY){
		if(shop_menu_buy==SHOP_BUY.MENU){
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
				if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
					var buy_moved=Shop_StepVerticalChoice(_buy_choice,_page_buy,buy_shown);
					_buy_choice=buy_moved[0];
					if(buy_moved[1]!=_page_buy){
						_page_buy=buy_moved[1];
						Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
					}
				}else{
					_buy_choice=Shop_StepPageChoice(_buy_choice,buy_shown,_page_buy);
					if(_buy_choice<4&&Shop_GetBuyPageMax()>1){
						var buy_page=Shop_StepListPage(_page_buy,_buy_choice,buy_shown);
						if(buy_page[0]!=_page_buy||buy_page[1]!=_buy_choice){
							_page_buy=buy_page[0];
							_buy_choice=buy_page[1];
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
		}else if(shop_menu_buy==SHOP_BUY.CONFIRM){
			var acted=false;
			var buy_result=SHOP_BUY_RESULT.NO;
			var clear_choice=false;
			if(Input_IsPressed(INPUT.CANCEL)){
				buy_result=SHOP_BUY_RESULT.NO;
				clear_choice=true;
				acted=true;
			}else if(Player_GetTextTyperChoice()==0){
				buy_result=Shop_TryBuy(Shop_GetBuyChoice());
				clear_choice=true;
				acted=true;
			}else if(Player_GetTextTyperChoice()==1){
				buy_result=SHOP_BUY_RESULT.NO;
				clear_choice=true;
				acted=true;
			}
			if(acted){
				Shop_SetBuyResult(buy_result);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				Shop_SetMenu(SHOP_MENU.BUY);
				Shop_SetMenuBuy(SHOP_BUY.MENU,_page_buy);
				if(clear_choice)Shop_ClearTextTyperChoice();
			}
		}
	}

	if(shop_menu==SHOP_MENU.SELL){
		if(shop_menu_sell==SHOP_SELL.MENU){
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
				// unsellable: no confirm / no tip — just ignore
			}
			if(Input_IsPressed(INPUT.CANCEL)||(Input_IsPressed(INPUT.CONFIRM)&&_sell_choice==8)){
				Shop_SetNextMenu(SHOP_MENU.MENU);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
				_menu_sell=-1;
			}
		}else if(shop_menu_sell==SHOP_SELL.CONFIRM){
			var sell_acted=false;
			var sell_result=SHOP_SELL_RESULT.NO;
			var sell_clear=false;
			if(Input_IsPressed(INPUT.CANCEL)){
				sell_clear=true;
				sell_acted=true;
			}else if(Player_GetTextTyperChoice()==0){
				sell_result=Shop_TrySell(_sell_choice);
				sell_clear=true;
				sell_acted=true;
			}else if(Player_GetTextTyperChoice()==1){
				sell_clear=true;
				sell_acted=true;
			}
			if(sell_acted){
				Shop_SetSellResult(sell_result);
				Shop_CallHostEvent(SHOP_HOST_EVENT.CONFIRM);
				if(sell_clear)Shop_ClearTextTyperChoice();
				if(sell_result==SHOP_SELL_RESULT.YES)_sell_choice=0;
				Shop_SetNextMenu(SHOP_MENU.SELL);
				Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
				Shop_SetState(SHOP_STATE.DIALOG);
				_dialog_pending=true;
			}
		}
	}

	if(shop_menu==SHOP_MENU.TALK){
		if(Input_IsPressed(INPUT.CANCEL)||(Input_IsPressed(INPUT.CONFIRM)&&_talk_choice==4)){
			Shop_SetNextMenu(SHOP_MENU.MENU);
			Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_SWITCH);
			Shop_SetState(SHOP_STATE.DIALOG);
			_dialog_pending=true;
		}else{
			var talk_shown=Shop_GetListShown(Shop_GetTalkNumber());
			var talk_choice_was=_talk_choice;
			var talk_page_was=_page_talk;
			if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
				var talk_moved=Shop_StepVerticalChoice(_talk_choice,_page_talk,talk_shown);
				_talk_choice=talk_moved[0];
				if(talk_moved[1]!=_page_talk){
					_page_talk=talk_moved[1];
					Shop_SetMenuTalk(_page_talk);
				}
			}else{
				_talk_choice=Shop_StepPageChoice(_talk_choice,talk_shown,_page_talk);
				if(_talk_choice<4&&Shop_GetTalkPageMax()>1){
					var talk_page=Shop_StepListPage(_page_talk,_talk_choice,talk_shown);
					if(talk_page[0]!=_page_talk||talk_page[1]!=_talk_choice){
						_page_talk=talk_page[0];
						_talk_choice=talk_page[1];
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

	if(shop_menu==SHOP_MENU.EXIT){
		if(fader.alpha>=1){
			Fader_Fade(1,0,20);
			BGM_Stop(4);
			var room_return=Storage_GetTempGeneral().Get(FLAG_TEMP_SHOP_ROOM_RETURN,-1);
			if(room_exists(room_return))room_goto(room_return);
		}
	}
}else if(shop_state==SHOP_STATE.DIALOG){
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
