/// Shop menus: main templates + buy/sell/talk UI builders

function Shop_DefineBuiltinMainTemplates(){
	Shop_DefineMainTemplate("default",[
		{action: SHOP_MAIN_ACTION.BUY,label_key:"shop.menu.choice.0"},
		{action: SHOP_MAIN_ACTION.DIALOG,label_key:"shop.menu.choice.1",dialog:""},
		{action: SHOP_MAIN_ACTION.TALK,label_key:"shop.menu.choice.2"},
		{action: SHOP_MAIN_ACTION.EXIT,label_key:"shop.menu.choice.3"}
	]);
	Shop_DefineMainTemplate("geno",[
		{action: SHOP_MAIN_ACTION.BUY,label_key:"shop.menu.choice.take",free:true},
		{action: SHOP_MAIN_ACTION.DIALOG,label_key:"shop.menu.choice.steal",dialog_key:"shop.menu.geno.steal"},
		{action: SHOP_MAIN_ACTION.DIALOG,label_key:"shop.menu.choice.read",dialog_key:"shop.menu.geno.read"},
		{action: SHOP_MAIN_ACTION.EXIT,label_key:"shop.menu.choice.3"}
	]);
}

///@arg name
///@arg slots  1 to 4 structs: action, label_key|label, free*, dialog_key|dialog*
function Shop_DefineMainTemplate(name,slots){
	var n=0;
	if(is_array(slots))n=array_length(slots);
	if(n<1||n>4){
		show_debug_message("Shop_DefineMainTemplate: need 1 to 4 slots ("+string(name)+")");
		return false;
	}
	global._shop_main_templates[$ string(name)]=slots;
	return true;
}

///@arg name
function Shop_ApplyMainTemplate(name){
	if(!instance_exists(shop))return false;
	if(!variable_struct_exists(global._shop_main_templates,string(name))){
		show_debug_message("Shop main template missing: "+string(name));
		return false;
	}
	var slots=global._shop_main_templates[$ string(name)];
	var n=array_length(slots);
	for(var i=0;i<4;i+=1){
		if(i>=n){
			Shop_SetMainChoice(i,SHOP_MAIN_ACTION.DIALOG,"");
			continue;
		}
		var s=slots[i];
		var action=s.action;
		var label="";
		if(variable_struct_exists(s,"label"))label=s.label;
		else if(variable_struct_exists(s,"label_key"))label=Lang_GetString(s.label_key);
		var free=variable_struct_exists(s,"free") ? s.free : false;
		var dialog="";
		if(variable_struct_exists(s,"dialog"))dialog=s.dialog;
		else if(variable_struct_exists(s,"dialog_key"))dialog=Lang_GetString(s.dialog_key);
		if(action==SHOP_MAIN_ACTION.BUY){
			Shop_SetMainChoice(i,action,label,free);
		}else if(action==SHOP_MAIN_ACTION.DIALOG){
			Shop_SetMainChoice(i,action,label,dialog);
		}else{
			Shop_SetMainChoice(i,action,label);
		}
	}
	shop._buy_free=false;
	return true;
}

function Shop_ResetMainChoices(){
	return Shop_ApplyMainTemplate("default");
}

///@arg slot  0..3
///@arg action  SHOP_MAIN_ACTION.*
///@arg label
///@arg opt*  BUY: free bool | DIALOG: dialog string
function Shop_SetMainChoice(){
	var SLOT=argument[0];
	var ACTION=argument[1];
	var LABEL=argument[2];
	var free=false;
	var dialog="";
	if(ACTION==SHOP_MAIN_ACTION.BUY){
		if(argument_count>=4)free=argument[3];
	}else if(ACTION==SHOP_MAIN_ACTION.DIALOG){
		if(argument_count>=4)dialog=argument[3];
	}
	if(!instance_exists(shop))return false;
	if(SLOT<0||SLOT>3)return false;
	shop._main_action[SLOT]=ACTION;
	shop._main_label[SLOT]=LABEL;
	shop._main_free[SLOT]=free;
	shop._main_dialog[SLOT]=dialog;
	return true;
}

///@arg slot
function Shop_GetMainAction(slot){
	if(!instance_exists(shop))return -1;
	if(slot<0||slot>3)return -1;
	return shop._main_action[slot];
}

///@arg slot
function Shop_GetMainLabel(slot){
	if(!instance_exists(shop))return "";
	if(slot<0||slot>3)return "";
	return shop._main_label[slot];
}

///@arg slot
function Shop_GetMainFree(slot){
	if(!instance_exists(shop))return false;
	if(slot<0||slot>3)return false;
	return shop._main_free[slot];
}

///@arg slot
function Shop_GetMainDialog(slot){
	if(!instance_exists(shop))return "";
	if(slot<0||slot>3)return "";
	return shop._main_dialog[slot];
}

///@arg menu  SHOP_MENU.*
function Shop_SetMenu(){
	var MENU=argument[0];
	if(!instance_exists(shop))return false;
	shop._menu=MENU;
	Shop_SetDialog("",false,false);
	Shop_SetDialog("",false,true);
	if(instance_exists(shop._inst_right_dialog))instance_destroy(shop._inst_right_dialog);
	if(instance_exists(shop._inst_menu_choice))instance_destroy(shop._inst_menu_choice);
	if(instance_exists(shop._inst_page))instance_destroy(shop._inst_page);

	if(MENU==SHOP_MENU.MENU){
		Shop_SetBuyFree(false);
		shop._menu_sell=-1;
		shop._menu_buy=-1;
		Shop_SetDialog(Shop_GetMenuDialog());
		if(Shop_GetMainLabel(shop._menu_choice)==""){
			for(var i=0;i<4;i+=1){
				if(Shop_GetMainLabel(i)!=""){
					shop._menu_choice=i;
					break;
				}
			}
		}
		var mcx=480+Lang_GetLayout("shop.menu_choice.x",0);
		var mcy=260+Lang_GetLayout("shop.menu_choice.y",0);
		shop._inst_menu_choice=instance_create_depth(mcx,mcy,DEPTH_SHOP.DIALOG,text_typer);
		var t="{font 1}{instant true}"+Shop_TyperPrefix();
		var inv=Item_GetInventoryItems();
		for(var i=0;i<4;i+=1){
			if(Shop_GetMainAction(i)==SHOP_MAIN_ACTION.SELL&&inv.GetCount()==0)t+="{color `gray`}";
			t+=Shop_GetMainLabel(i)+"\n";
			if(Shop_GetMainAction(i)==SHOP_MAIN_ACTION.SELL)t+="{color `white`}";
		}
		shop._inst_menu_choice.text=t;
		Shop_CallHostEvent(SHOP_HOST_EVENT.SHOP_START);
	}else if(MENU==SHOP_MENU.BUY){
		Shop_SetMenuBuy(SHOP_BUY.MENU,shop._page_buy);
		Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_START);
	}else if(MENU==SHOP_MENU.SELL){
		Shop_SetMenuSell(SHOP_SELL.MENU);
		Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_START);
	}else if(MENU==SHOP_MENU.TALK){
		Shop_SetMenuTalk(shop._page_talk);
		Shop_CallHostEvent(SHOP_HOST_EVENT.MENU_START);
	}else if(MENU==SHOP_MENU.EXIT){
		Shop_End();
	}
	return true;
}

/// PAGE: page index. VERTICAL: window start.
///@arg page
///@arg shown
function Shop_ListWindow(){
	var PAGE=argument[0];
	var SHOWN=argument[1];
	var first=PAGE*4;
	if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
		var max_first=max(0,SHOWN-4);
		if(PAGE<0)PAGE=0;
		if(PAGE>max_first)PAGE=max_first;
		first=PAGE;
	}
	return [PAGE,first];
}

/// 4 is Exit. A row past the filled slots drops back onto the last filled row.
///@arg choice
///@arg first
///@arg shown
function Shop_ClampListChoice(){
	var CHOICE=argument[0];
	var FIRST=argument[1];
	var SHOWN=argument[2];
	var slots=min(4,max(0,SHOWN-FIRST));
	if(slots<=0)return 4;
	if(CHOICE!=4&&(CHOICE<0||CHOICE>=slots))return slots-1;
	return CHOICE;
}

///@arg menu  SHOP_BUY.*
///@arg page*
function Shop_SetMenuBuy(){
	var MENU=argument[0];
	var PAGE=shop._page_buy;
	if(argument_count>=2)PAGE=argument[1];
	if(!instance_exists(shop))return false;
	shop._menu_buy=MENU;

	if(MENU==SHOP_BUY.MENU){
		var shown=Shop_GetListShown(Shop_GetBuyNumber());
		var rows=4;
		var win=Shop_ListWindow(PAGE,shown);
		PAGE=win[0];
		var first=win[1];
		shop._page_buy=PAGE;
		var text="";
		for(var i=first;i<first+rows;i+=1){
			if(i<shown){
				if(Shop_GetSlotState(i)!=SHOP_SLOT.SOLD_OUT){
					var price_show=Shop_IsBuyFree() ? 0 : Shop_GetBuyPrice(i);
					text+=Shop_FormatPrice(price_show)+"G - "+Shop_GetBuyName(i)+"\n";
				}else{
					text+="{color_text `gray`}"+Lang_GetString("shop.menu.sellout")+"{color_text `white`}\n";
				}
			}else{
				text+="\n";
			}
		}
		text+=Lang_GetString("shop.menu.exit");
		Shop_SetDialog(text,true);
		shop._buy_choice=Shop_ClampListChoice(shop._buy_choice,first,shown);
		if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.PAGE){
			Shop_SetPageIndicator(PAGE,Shop_GetBuyPageMax());
		}else if(instance_exists(shop._inst_page)){
			instance_destroy(shop._inst_page);
		}
	}else{
		var confirm="{instant true}{choice_dir 1}{choice_confirm_snd false}";
		if(Shop_IsBuyFree()){
			confirm+=Lang_GetString("shop.menu.take.confirm");
		}else{
			var price=Shop_GetBuyPrice(Shop_GetBuyChoice());
			confirm+="{define `PRICE` `"+string(price)+"`}"+Lang_GetString("shop.menu.buy.confirm");
		}
		Shop_SetRightDialog(confirm);
	}
	return true;
}

///@arg menu  SHOP_SELL.*
function Shop_SetMenuSell(){
	var MENU=argument[0];
	if(!instance_exists(shop))return false;
	shop._menu_sell=MENU;
	var inv=Item_GetInventoryItems();
	if(MENU==SHOP_SELL.MENU){
		var text="";
		var text2="";
		var count=inv.GetCount();
		var cap=min(8,inv.GetCapacity());
		var thanks=clamp(shop._sell_thanks,0,max(0,cap-count));
		var thanks_start=cap-thanks;
		var thanks_label="{color_text `gray`}"+Lang_GetString("shop.menu.sell.thanks")+"{color_text `white`}";
		for(var i=0;i<8;i+=2){
			if(i<count){
				var item_l=inv.Get(i);
				text+=Shop_GetSellPriceLabel(item_l)+" - "+Item_GetTypeManager().GetNameOrFallback(item_l)+"\n";
			}else if(thanks>0&&i>=thanks_start&&i<cap){
				text+=thanks_label+"\n";
			}else if(thanks>0&&i<cap){
				text+="\n";
			}
			if(i+1<count){
				var item_r=inv.Get(i+1);
				text2+=Shop_GetSellPriceLabel(item_r)+" - "+Item_GetTypeManager().GetNameOrFallback(item_r)+"\n";
			}else if(thanks>0&&i+1>=thanks_start&&i+1<cap){
				text2+=thanks_label+"\n";
			}else if(thanks>0&&i+1<cap){
				text2+="\n";
			}
		}
		var rows_used=thanks>0 ? ((cap+1) div 2) : ((count+1) div 2);
		for(var pad=0;pad<4-rows_used;pad+=1){
			text+="\n";
		}
		text+=Lang_GetString("shop.menu.exit");
		Shop_SetDialog(text,true,false);
		Shop_SetDialog(text2,true,true);
		Dialog_Clear();
		if(count==0){
			shop._sell_choice=8;
		}
	}else{
		var slot=shop._sell_choice;
		var item_id=inv.Get(slot);
		var p=Shop_GetItemSellPrice(item_id);
		var confirm="{define `PRICE` `"+string(p)+"`}{font 1}{instant true}{choice_dir 0}{choice_confirm_snd false}"+Lang_GetString("shop.menu.sell.confirm");
		Shop_SetDialog(confirm);
		if(instance_exists(shop._inst_dialog[0])){
			shop._inst_dialog[0].x+=100+Lang_GetLayout("shop.sell.confirm.x",0);
			shop._inst_dialog[0].y+=40+Lang_GetLayout("shop.sell.confirm.y",0);
		}
		if(instance_exists(shop._inst_dialog[1])){
			instance_destroy(shop._inst_dialog[1]);
			shop._inst_dialog[1]=noone;
		}
		if(instance_exists(shop._inst_right_dialog)){
			instance_destroy(shop._inst_right_dialog);
			shop._inst_right_dialog=noone;
		}
	}
	return true;
}

///@arg page
function Shop_SetMenuTalk(PAGE){
	if(!instance_exists(shop))return false;
	var shown=Shop_GetListShown(Shop_GetTalkNumber());
	var rows=4;
	var win=Shop_ListWindow(PAGE,shown);
	PAGE=win[0];
	var first=win[1];
	shop._page_talk=PAGE;
	var text="";
	var new_suffix=Lang_GetString("shop.menu.talk.new");
	for(var i=first;i<first+rows;i+=1){
		if(i<shown){
			if(Shop_IsTalkNew(i)){
				text+="{color `yellow`}"+Shop_GetTalkName(i)+new_suffix+"{color `white`}\n";
			}else{
				text+=Shop_GetTalkName(i)+"\n";
			}
		}else{
			text+="\n";
		}
	}
	text+=Lang_GetString("shop.menu.exit");
	Shop_SetDialog(text,true);
	shop._talk_choice=Shop_ClampListChoice(shop._talk_choice,first,shown);
	if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.PAGE){
		Shop_SetPageIndicator(PAGE,Shop_GetTalkPageMax());
	}else if(instance_exists(shop._inst_page)){
		instance_destroy(shop._inst_page);
	}
	return true;
}

///@arg page
///@arg page_max
function Shop_SetPageIndicator(){
	var PAGE=argument[0];
	var PAGE_MAX=argument[1];
	if(!instance_exists(shop))return false;
	if(PAGE_MAX<=1)return false;
	if(instance_exists(shop._inst_page))instance_destroy(shop._inst_page);
	var px=240+Lang_GetLayout("shop.dialog.base_x",0);
	var py=420+Lang_GetLayout("shop.dialog.base_y",0);
	shop._inst_page=instance_create_depth(px,py,DEPTH_SHOP.DIALOG,text_typer);
	shop._inst_page.text="{font 1}{instant true}{scale 2}{gui false}{depth "+string(DEPTH_SHOP.DIALOG)+"}{define `PAGE` `"+string(PAGE+1)+"`}"+Lang_GetString("shop.menu.page");
	return true;
}

/// Buy/talk list cursor. 4 is Exit. Empty rows are not stops.
///@arg choice
///@arg count
///@arg page
function Shop_StepPageChoice(){
	var CHOICE=argument[0];
	var COUNT=argument[1];
	var PAGE=argument[2];
	var slots=min(4,max(0,COUNT-PAGE*4));
	if(slots==0){
		CHOICE=4;
	}else if(CHOICE!=4&&(CHOICE<0||CHOICE>=slots)){
		CHOICE=slots-1;
	}
	if(Input_IsPressed(INPUT.DOWN)){
		if(slots==0){
			CHOICE=4;
		}else if(CHOICE==4){
			CHOICE=0;
		}else if(CHOICE>=slots-1){
			CHOICE=4;
		}else{
			CHOICE+=1;
		}
	}
	if(Input_IsPressed(INPUT.UP)){
		if(slots==0){
			CHOICE=4;
		}else if(CHOICE==4){
			CHOICE=slots-1;
		}else if(CHOICE<=0){
			CHOICE=4;
		}else{
			CHOICE-=1;
		}
	}
	return CHOICE;
}

///@arg count
function Shop_GetListShown(){
	var COUNT=argument[0];

	return min(COUNT,SHOP_MENU_LIST_PAGE_MAX*4);
}

///@arg page
///@arg choice
///@arg count
function Shop_StepListPage(){
	var PAGE=argument[0];
	var CHOICE=argument[1];
	var COUNT=argument[2];

	var page_max=max(1,ceil(COUNT/4));
	if(page_max<=1){
		return [PAGE,CHOICE];
	}
	var turned=false;
	if(Input_IsPressed(INPUT.RIGHT)){
		PAGE=(PAGE>=page_max-1 ? 0 : PAGE+1);
		turned=true;
	}
	if(Input_IsPressed(INPUT.LEFT)){
		PAGE=(PAGE<1 ? page_max-1 : PAGE-1);
		turned=true;
	}
	if(turned){
		var slots=min(4,max(0,COUNT-PAGE*4));
		if(CHOICE!=4&&CHOICE>=slots){
			CHOICE=(slots<=0 ? 4 : slots-1);
		}
	}
	return [PAGE,CHOICE];
}

///Four-row window. 4 is Exit. Stops at the ends.
///@arg choice
///@arg first
///@arg count
function Shop_StepVerticalChoice(){
	var CHOICE=argument[0];
	var FIRST=argument[1];
	var COUNT=argument[2];

	if(COUNT<=0){
		return [4,0];
	}
	var first_max=max(0,COUNT-4);
	if(FIRST<0){
		FIRST=0;
	}
	if(FIRST>first_max){
		FIRST=first_max;
	}
	if(CHOICE!=4){
		if(CHOICE<0){
			CHOICE=0;
		}
		if(CHOICE>3){
			CHOICE=3;
		}
		if(FIRST+CHOICE>=COUNT){
			CHOICE=COUNT-1-FIRST;
		}
	}

	var slot=FIRST;
	if(CHOICE!=4){
		slot=FIRST+CHOICE;
	}
	if(Input_IsPressed(INPUT.DOWN)){
		if(CHOICE!=4){
			if(slot+1<COUNT){
				slot+=1;
			}else{
				CHOICE=4;
			}
		}
	}
	if(Input_IsPressed(INPUT.UP)){
		if(CHOICE==4){
			slot=COUNT-1;
			CHOICE=0;
		}else if(slot>0){
			slot-=1;
		}
	}

	if(CHOICE==4){
		FIRST=first_max;
	}else{
		while(slot>=FIRST+4){
			FIRST+=1;
		}
		while(slot<FIRST){
			FIRST-=1;
		}
		CHOICE=slot-FIRST;
	}
	return [CHOICE,FIRST];
}

function Shop_DrawListScrollbar(){
	if(SHOP_MENU_LIST_LAYOUT_CURRENT!=SHOP_MENU_LIST_LAYOUT.VERTICAL)return false;
	if(!instance_exists(shop))return false;
	if(Shop_GetState()!=SHOP_STATE.MENU)return false;
	var count=0;
	var current=-1;
	var first=0;
	if(Shop_GetMenu()==SHOP_MENU.BUY&&Shop_GetMenuBuy()==SHOP_BUY.MENU){
		count=Shop_GetListShown(Shop_GetBuyNumber());
		first=shop._page_buy;
		if(shop._buy_choice<4)current=first+shop._buy_choice;
	}else if(Shop_GetMenu()==SHOP_MENU.TALK){
		count=Shop_GetListShown(Shop_GetTalkNumber());
		first=shop._page_talk;
		if(shop._talk_choice<4)current=first+shop._talk_choice;
	}else{
		return false;
	}
	if(count<=4){
		return false;
	}
	var bar_x=400;
	var bar_y=354;
	var proc=0;
	var arrow=sin(current_time/150)*3;
	repeat(count){
		draw_sprite(spr_battle_menu_item_scrollbar_dot,proc==current,bar_x,bar_y-10*floor(count/2)+10*proc);
		proc+=1;
	}
	if(first!=0){
		draw_sprite(spr_battle_menu_item_scrollbar_arrow,0,bar_x,bar_y-10*floor(count/2)-10-arrow);
	}
	if(first!=count-4){
		draw_sprite_ext(spr_battle_menu_item_scrollbar_arrow,0,bar_x,bar_y-10*floor(count/2)+10*count+arrow,1,-1,0,c_white,1);
	}
	return true;
}
