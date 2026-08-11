/// MENU_SWITCH — exit / empty-sell / steal-once / unlock conditional stock
if(Shop_GetNextMenu()==SHOP_MENU.EXIT){
	Dialog_Add(Lang_GetString(_geno ? "shop.demo.exit.geno" : "shop.demo.exit"));
}

if(Shop_GetNextMenu()==SHOP_MENU.SELL){
	if(Item_GetInventoryItems().GetCount()<=0){
		Shop_SetNextMenu(SHOP_MENU.MENU);
		Dialog_Add(Lang_GetString("shop.demo.sell.empty"));
	}
}

// Geno steal (main slot 1): only once; gold via {gold} in shop.demo.steal
if(_geno&&Shop_GetNextMenu()==SHOP_MENU.MENU&&shop._menu_choice==1){
	var steal_key=Shop_GetHostShortName()+"_steal";
	if(Plot_Get(steal_key,0)==0){
		Plot_Set(steal_key,1);
		Shop_SetMainChoice(1,SHOP_MAIN_ACTION.DIALOG,Lang_GetString("shop.menu.choice.steal"),Lang_GetString("shop.demo.steal.done"));
	}
}

// Talk 0 progressed → unlock ribbon (index 2)
if(Shop_GetTalkProgress(0)>=2&&Shop_GetBuyNumber()>2){
	if(Shop_GetSlotState(2)==SHOP_SLOT.LOCKED){
		Shop_PatchBuy(2,{
			state:SHOP_SLOT.OPEN,
			desc:Lang_GetString("shop.demo.buy.ribbon.desc")
		});
	}
}

// Joke (talk 3) done once → append hidden talk
var bonus_key=Shop_GetHostShortName()+"_bonus_talk";
if(Shop_GetTalkProgress(3)>=2&&Plot_Get(bonus_key,0)==0){
	Plot_Set(bonus_key,1);
	Shop_AddTalk(Lang_GetString("shop.demo.talk.bonus.name"),[
		Lang_GetString("shop.demo.talk.bonus")
	]);
	Shop_SetTalkProgress(Shop_GetTalkNumber()-1,1);
}
