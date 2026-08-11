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
function Shop_GetBuyEntry(index){
	if(!instance_exists(shop))return undefined;
	if(index<0||index>=array_length(shop._buy_list))return undefined;
	return shop._buy_list[index];
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
	var item_id=argument[0];
	var price=argument[1];
	var desc="";
	var state=SHOP_SLOT.OPEN;
	var stock=1;
	var display_name="";
	if(argument_count>=3)desc=argument[2];
	if(argument_count>=4)state=argument[3];
	if(argument_count>=5)stock=argument[4];
	if(argument_count>=6)display_name=argument[5];
	return Shop_SetBuy(Shop_GetBuyNumber(),item_id,price,desc,state,stock,display_name);
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
	var index=argument[0];
	var item_id=argument[1];
	var price=argument[2];
	var desc="";
	var state=SHOP_SLOT.OPEN;
	var stock=1;
	var display_name="";
	if(argument_count>=4)desc=argument[3];
	if(argument_count>=5)state=argument[4];
	if(argument_count>=6)stock=argument[5];
	if(argument_count>=7)display_name=argument[6];
	if(!instance_exists(shop))return false;
	var n=array_length(shop._buy_list);
	if(index<0||index>n)return false;
	if(stock<-1)stock=-1;
	var entry={
		item_id:item_id,
		price:price,
		desc:desc,
		state:state,
		stock:stock
	};
	if(display_name!="")entry.display_name=display_name;
	if(stock==0)entry.state=SHOP_SLOT.SOLD_OUT;
	if(index==n){
		array_push(shop._buy_list,entry);
	}else{
		shop._buy_list[index]=entry;
	}
	Shop_LoadBuyStock(index);
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
	return max(1,ceil(Shop_GetBuyNumber()/4));
}

function Shop_GetBuyChoice(){
	if(!instance_exists(shop))return -1;
	return shop._page_buy*4+shop._buy_choice;
}

///@arg index
function Shop_GetBuyName(index){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e))return "";
	if(variable_struct_exists(e,"display_name"))return e.display_name;
	return Item_GetTypeManager().GetNameOrFallback(e.item_id);
}

///@arg index
function Shop_GetBuyPrice(index){
	var e=Shop_GetBuyEntry(index);
	return is_undefined(e) ? 0 : e.price;
}

///@arg index
function Shop_GetBuyDesc(index){
	var e=Shop_GetBuyEntry(index);
	return is_undefined(e) ? "" : e.desc;
}

///@arg index
function Shop_GetSlotState(index){
	var e=Shop_GetBuyEntry(index);
	return is_undefined(e) ? SHOP_SLOT.LOCKED : e.state;
}

/// Remaining stock; -1 = infinite. Missing field defaults to 1.
///@arg index
function Shop_GetBuyStock(index){
	var e=Shop_GetBuyEntry(index);
	if(is_undefined(e))return 1;
	if(!variable_struct_exists(e,"stock"))return 1;
	return e.stock;
}

/// True only for OPEN (not LOCKED / SOLD_OUT).
///@arg index
function Shop_IsSlotOpen(index){
	return Shop_GetSlotState(index)==SHOP_SLOT.OPEN;
}

///@arg name
///@arg dialog*  string, or array of stage strings
///@arg flag_key*  static key; default {hostShortName}_talk_{talkIndex}
function Shop_AddTalk(){
	var name=argument[0];
	var dialog="";
	var flag_key="";
	if(argument_count>=2)dialog=argument[1];
	if(argument_count>=3)flag_key=argument[2];
	if(!instance_exists(shop))return false;

	var dialogs=[];
	if(is_array(dialog)){
		dialogs=dialog;
	}else if(is_string(dialog)&&dialog!=""){
		dialogs=[dialog];
	}

	var index=array_length(shop._talk_list);
	if(flag_key=="")flag_key=Shop_GetHostShortName()+"_talk_"+string(index);

	array_push(shop._talk_list,{
		name:name,
		dialogs:dialogs,
		flag_key:flag_key
	});
	return true;
}

function Shop_GetTalkNumber(){
	return instance_exists(shop) ? array_length(shop._talk_list) : 0;
}

function Shop_GetTalkPageMax(){
	return max(1,ceil(Shop_GetTalkNumber()/4));
}

function Shop_GetTalkChoice(){
	if(!instance_exists(shop))return -1;
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

///@arg item_id
function Shop_GetSellPriceLabel(item_id){
	var p=Shop_GetItemSellPrice(item_id);
	if(p<=0)return Shop_GetSellRefuseText()+"G";
	return string(p)+"G";
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
	audio_play_sound(snd_item_equip,0,false);
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
	audio_play_sound(snd_item_equip,0,false);
	return SHOP_SELL_RESULT.YES;
}
