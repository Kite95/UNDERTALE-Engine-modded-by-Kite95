/// Shop catalog: buy list, talk list, stock/talk save, TryBuy/TrySell

/// Host object name without shop_host_ prefix (talk/stock keys).
function Shop_GetHostShortName(){
	var host_name="shop";
	if(instance_exists(shop)&&object_exists(shop._host_object)){
		host_name=object_get_name(shop._host_object);
	}
	var prefix="shop_host_";
	if(string_pos(prefix,host_name)==1){
		host_name=string_delete(host_name,1,string_length(prefix));
	}
	return host_name;
}

///@arg index
function Shop_GetBuyEntry(INDEX){
	if(!instance_exists(shop))return undefined;
	if(INDEX<0||INDEX>=array_length(shop._buy_list))return undefined;
	return shop._buy_list[INDEX];
}

/// Load stock from static if key exists (after AddBuy / SetBuy).
///@arg index
function Shop_LoadBuyStock(index){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e))return false;
	var key=Shop_GetHostShortName()+"_stock_"+string(index);
	var data=Storage_GetStaticPlot().GetData();
	if(!variable_struct_exists(data,key))return false;
	var s=data[$ key];
	if(!is_real(s))return false;
	e.stock=s;
	if(s==0){
		e.state=SHOP_SLOT.SOLD_OUT;
	}else if(s>0&&e.state==SHOP_SLOT.SOLD_OUT){
		e.state=SHOP_SLOT.OPEN;
	}
	return true;
}

/// Persist finite stock; infinite (-1) removes the key.
///@arg index
function Shop_SaveBuyStock(index){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e))return false;
	var key=Shop_GetHostShortName()+"_stock_"+string(index);
	var data=Storage_GetStaticPlot().GetData();
	var s=variable_struct_exists(e,"stock") ? e.stock : 1;
	if(s<0){
		if(variable_struct_exists(data,key))variable_struct_remove(data,key);
	}else{
		data[$ key]=s;
	}
	return true;
}

///@arg item_id
///@arg price
///@arg description*
///@arg state*  SHOP_SLOT.* (default OPEN)
///@arg stock*  remaining count (default 1); -1 = infinite
///@arg display_name*  override item name shown (default "" uses real item name)
function Shop_AddBuy(){
	var ITEM_ID=argument[0];
	var PRICE=argument[1];
	var DESC="";
	var STATE=SHOP_SLOT.OPEN;
	var STOCK=1;
	var DISPLAY_NAME="";
	if(argument_count>=3)DESC=argument[2];
	if(argument_count>=4)STATE=argument[3];
	if(argument_count>=5)STOCK=argument[4];
	if(argument_count>=6)DISPLAY_NAME=argument[5];
	return Shop_SetBuy(Shop_GetBuyNumber(),ITEM_ID,PRICE,DESC,STATE,STOCK,DISPLAY_NAME);
}

/// Replace buy-list entry at index (or append if index==length).
///@arg index
///@arg item_id
///@arg price
///@arg description*
///@arg state*  SHOP_SLOT.* (default OPEN)
///@arg stock*  remaining count (default 1); -1 = infinite
///@arg display_name*  override item name shown (default "" uses real item name)
function Shop_SetBuy(){
	var INDEX=argument[0];
	var ITEM_ID=argument[1];
	var PRICE=argument[2];
	var DESC="";
	var STATE=SHOP_SLOT.OPEN;
	var STOCK=1;
	var DISPLAY_NAME="";
	if(argument_count>=4)DESC=argument[3];
	if(argument_count>=5)STATE=argument[4];
	if(argument_count>=6)STOCK=argument[5];
	if(argument_count>=7)DISPLAY_NAME=argument[6];
	if(!instance_exists(shop))return false;
	var n=array_length(shop._buy_list);
	if(INDEX<0||INDEX>n)return false;
	if(STOCK<-1)STOCK=-1;
	var entry={
		item_id:ITEM_ID,
		price:PRICE,
		desc:DESC,
		state:STATE,
		stock:STOCK
	};
	if(DISPLAY_NAME!="")entry.display_name=DISPLAY_NAME;
	if(STOCK==0)entry.state=SHOP_SLOT.SOLD_OUT;
	if(INDEX==n){
		array_push(shop._buy_list,entry);
	}else{
		shop._buy_list[INDEX]=entry;
	}
	Shop_LoadBuyStock(INDEX);
	return true;
}

/// Patch fields on an existing buy entry. Optional keys: price, desc, state, stock, display_name.
/// stock: -1 infinite; 0 → SOLD_OUT; >0 restocks SOLD_OUT → OPEN (and saves).
///@arg index
///@arg patch
function Shop_PatchBuy(index,patch){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e)||!is_struct(patch))return false;
	if(variable_struct_exists(patch,"price"))e.price=patch.price;
	if(variable_struct_exists(patch,"desc"))e.desc=patch.desc;
	if(variable_struct_exists(patch,"display_name"))e.display_name=patch.display_name;
	if(variable_struct_exists(patch,"state"))e.state=patch.state;
	if(variable_struct_exists(patch,"stock")){
		var stock=patch.stock;
		if(stock<0){
			e.stock=-1;
		}else{
			e.stock=stock;
			if(stock==0){
				e.state=SHOP_SLOT.SOLD_OUT;
			}else if(e.state==SHOP_SLOT.SOLD_OUT){
				e.state=SHOP_SLOT.OPEN;
			}
		}
		Shop_SaveBuyStock(index);
	}
	return true;
}

///@arg index
function Shop_RemoveBuy(index){
	if(!instance_exists(shop))return false;
	if(index<0||index>=array_length(shop._buy_list))return false;
	array_delete(shop._buy_list,index,1);
	return true;
}

function Shop_ClearBuy(){
	if(!instance_exists(shop))return false;
	shop._buy_list=[];
	return true;
}

function Shop_GetBuyNumber(){
	return instance_exists(shop) ? array_length(shop._buy_list) : 0;
}

function Shop_GetBuyPageMax(){
	return max(1,ceil(Shop_GetListShown(Shop_GetBuyNumber())/4));
}

function Shop_GetBuyChoice(){
	if(!instance_exists(shop))return -1;
	if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
		return shop._page_buy+shop._buy_choice;
	}
	return shop._page_buy*4+shop._buy_choice;
}

///@arg index
function Shop_GetBuyName(INDEX){
	var e=Shop_GetBuyEntry(INDEX);
	if(is_undefined(e))return "";
	if(variable_struct_exists(e,"display_name"))return e.display_name;
	return Item_GetTypeManager().GetNameOrFallback(e.item_id);
}

///@arg index
function Shop_GetBuyPrice(INDEX){
	var e=Shop_GetBuyEntry(INDEX);
	return is_undefined(e) ? 0 : e.price;
}

///@arg index
function Shop_GetBuyDesc(INDEX){
	var e=Shop_GetBuyEntry(INDEX);
	return is_undefined(e) ? "" : e.desc;
}

///@arg index
function Shop_GetSlotState(INDEX){
	var e=Shop_GetBuyEntry(INDEX);
	return is_undefined(e) ? SHOP_SLOT.LOCKED : e.state;
}

/// Remaining stock; -1 = infinite. Missing field defaults to 1.
///@arg index
function Shop_GetBuyStock(INDEX){
	var e=Shop_GetBuyEntry(INDEX);
	if(is_undefined(e))return 1;
	if(!variable_struct_exists(e,"stock"))return 1;
	return e.stock;
}

/// True only for OPEN (not LOCKED / SOLD_OUT).
///@arg index
function Shop_IsSlotOpen(INDEX){
	return Shop_GetSlotState(INDEX)==SHOP_SLOT.OPEN;
}

///@arg name
///@arg dialog*  string, or array of stage strings
///@arg flag_key*  static key; default {hostShortName}_talk_{talkIndex}
function Shop_AddTalk(){
	var NAME=argument[0];
	var DIALOG="";
	var FLAG_KEY="";
	if(argument_count>=2)DIALOG=argument[1];
	if(argument_count>=3)FLAG_KEY=argument[2];
	if(!instance_exists(shop))return false;

	var dialogs=[];
	if(is_array(DIALOG)){
		dialogs=DIALOG;
	}else if(is_string(DIALOG)&&DIALOG!=""){
		dialogs=[DIALOG];
	}

	var index=array_length(shop._talk_list);
	if(FLAG_KEY=="")FLAG_KEY=Shop_GetHostShortName()+"_talk_"+string(index);

	array_push(shop._talk_list,{
		name:NAME,
		dialogs:dialogs,
		flag_key:FLAG_KEY
	});
	return true;
}

function Shop_GetTalkNumber(){
	return instance_exists(shop) ? array_length(shop._talk_list) : 0;
}

function Shop_GetTalkPageMax(){
	return max(1,ceil(Shop_GetListShown(Shop_GetTalkNumber())/4));
}

function Shop_GetTalkChoice(){
	if(!instance_exists(shop))return -1;
	if(SHOP_MENU_LIST_LAYOUT_CURRENT==SHOP_MENU_LIST_LAYOUT.VERTICAL){
		return shop._page_talk+shop._talk_choice;
	}
	return shop._page_talk*4+shop._talk_choice;
}

///@arg index
function Shop_GetTalkName(index){
	if(!instance_exists(shop))return "";
	if(index<0||index>=array_length(shop._talk_list))return "";
	return shop._talk_list[index].name;
}

/// 0 never / odd = NEW unread / even = read (+ NEW for next if more)
///@arg index
function Shop_GetTalkProgress(index){
	if(!instance_exists(shop))return 0;
	if(index<0||index>=array_length(shop._talk_list))return 0;
	return Plot_Get(shop._talk_list[index].flag_key,0);
}

///@arg index
///@arg progress
function Shop_SetTalkProgress(index,progress){
	if(!instance_exists(shop))return false;
	if(index<0||index>=array_length(shop._talk_list))return false;
	Plot_Set(shop._talk_list[index].flag_key,progress);
	return true;
}

///@arg index
function Shop_GetTalkStageCount(index){
	if(!instance_exists(shop))return 0;
	if(index<0||index>=array_length(shop._talk_list))return 0;
	return array_length(shop._talk_list[index].dialogs);
}

///@arg index
function Shop_GetTalkDialogIndex(index){
	var n=Shop_GetTalkStageCount(index);
	if(n<=0)return 0;
	var p=Shop_GetTalkProgress(index);
	var stage=0;
	if(p<=0){
		stage=0;
	}else if(p mod 2==1){
		stage=(p-1) div 2;
	}else{
		stage=p div 2;
	}
	return clamp(stage,0,n-1);
}

///@arg index
function Shop_IsTalkNew(index){
	var n=Shop_GetTalkStageCount(index);
	if(n<=0)return false;
	var p=Shop_GetTalkProgress(index);
	if(p==1)return true;
	if(p>=3&&(p mod 2==1))return true;
	if(n>1&&p>=2&&(p mod 2==0)&&(p div 2)<n)return true;
	return false;
}

///@arg index
function Shop_GetTalkDialog(index){
	if(!instance_exists(shop))return "";
	if(index<0||index>=array_length(shop._talk_list))return "";
	var dialogs=shop._talk_list[index].dialogs;
	var n=array_length(dialogs);
	if(n<=0)return "";
	return dialogs[Shop_GetTalkDialogIndex(index)];
}

/// After selecting a talk: 0/1→2, odd→+1, even→+2 (cap at 2*stageCount).
///@arg index
function Shop_AdvanceTalk(index){
	var n=Shop_GetTalkStageCount(index);
	if(n<=0)return false;
	var p=Shop_GetTalkProgress(index);
	var next;
	if(p<=0){
		next=2;
	}else if(p mod 2==1){
		next=p+1;
	}else{
		next=p+2;
	}
	var maxp=2*n;
	if(next>maxp)next=maxp;
	Shop_SetTalkProgress(index,next);
	return true;
}

/// Sell price; 0 = unsellable. Items must define GetShopSellPrice().
///@arg item_id
function Shop_GetItemSellPrice(item_id){
	var t=Item_GetTypeManager().GetOrUndefined(item_id);
	if(is_undefined(t))return 0;
	if(variable_struct_exists(t,"GetShopSellPrice")&&is_method(t.GetShopSellPrice)){
		return t.GetShopSellPrice();
	}
	return 0;
}

/// Host may set _sell_refuse_text.
function Shop_GetSellRefuseText(){
	if(instance_exists(shop)&&instance_exists(shop._host_inst)){
		if(variable_instance_exists(shop._host_inst,"_sell_refuse_text")){
			var t=shop._host_inst._sell_refuse_text;
			if(is_string(t)&&t!="")return t;
		}
	}
	return Lang_GetString("shop.menu.sell.refuse");
}

/// Single-digit prices get a leading 0 so list columns line up.
///@arg price
function Shop_FormatPrice(){
	var PRICE=argument[0];
	var text=string(PRICE);
	if(PRICE>=0&&PRICE<10)text="0"+text;
	return text;
}

///@arg item_id
function Shop_GetSellPriceLabel(ITEM_ID){
	var p=Shop_GetItemSellPrice(ITEM_ID);
	if(p<=0)return Shop_GetSellRefuseText()+"G";
	return Shop_FormatPrice(p)+"G";
}

///@arg index  buy-list index
function Shop_TryBuy(index){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e))return SHOP_BUY_RESULT.UNABLE;
	if(!Shop_IsSlotOpen(index))return SHOP_BUY_RESULT.UNABLE;
	var inv=Item_GetInventoryItems();
	var price=Shop_IsBuyFree() ? 0 : e.price;
	if(Player_GetGold()<price)return SHOP_BUY_RESULT.NO_MONEY;
	if(inv.GetCount()>=inv.GetCapacity())return SHOP_BUY_RESULT.NO_ROOM;
	if(price>0)Player_SetGold(Player_GetGold()-price);
	inv.Add(e.item_id);
	shop._buy_item=e.item_id;
	var stock=Shop_GetBuyStock(index);
	if(stock>=0){
		stock-=1;
		e.stock=stock;
		if(stock<=0){
			e.stock=0;
			e.state=SHOP_SLOT.SOLD_OUT;
		}
		Shop_SaveBuyStock(index);
	}
	SFX_Play(snd_item_equip,0,false);
	return SHOP_BUY_RESULT.YES;
}

///@arg slot  inventory slot
function Shop_TrySell(slot){
	var inv=Item_GetInventoryItems();
	if(slot<0||slot>=inv.GetCount())return SHOP_SELL_RESULT.UNABLE;
	var item_id=inv.Get(slot);
	var price=Shop_GetItemSellPrice(item_id);
	if(price<=0)return SHOP_SELL_RESULT.UNABLE;
	shop._sell_item=item_id;
	Player_SetGold(Player_GetGold()+price);
	inv.Remove(slot);
	if(instance_exists(shop))shop._sell_thanks+=1;
	SFX_Play(snd_item_equip,0,false);
	return SHOP_SELL_RESULT.YES;
}
