/// INIT — catalog + route template
Shop_SetMainChoice(1,SHOP_MAIN_ACTION.SELL,Lang_GetString("shop.menu.choice.1"));
//_geno=(Player_GetKills()>=1);

// 0: default stock 1
Shop_AddBuy(ITEM_BANDAGE,15,Lang_GetString("shop.demo.buy.bandage.desc"));
// 1: stock 2
Shop_AddBuy(ITEM_STICK,5,Lang_GetString("shop.demo.buy.stick.desc"),SHOP_SLOT.OPEN,2);
// 2: locked until Talk 0 heard once
Shop_AddBuy(ITEM_FADED_RIBBON,25,Lang_GetString("shop.demo.buy.ribbon.locked"),SHOP_SLOT.LOCKED);
// 3: display; geno Take unlocks
Shop_AddBuy(ITEM_TOY_KNIFE,50,Lang_GetString("shop.demo.buy.knife.desc"),SHOP_SLOT.LOCKED);
// 4: phone
Shop_AddBuy(ITEM_PHONE_TML,100,Lang_GetString("shop.demo.buy.phone.desc"));
// 5: mystery box — infinite stock, custom shelf name
Shop_AddBuy(ITEM_BANDAGE,200,Lang_GetString("shop.demo.buy.mystery.desc"),SHOP_SLOT.OPEN,-1);
Shop_PatchBuy(5,{display_name:Lang_GetString("shop.demo.buy.mystery.name")});

Shop_AddTalk(Lang_GetString("shop.demo.talk.name.0"),[
	Lang_GetString("shop.demo.talk.0"),
	Lang_GetString("shop.demo.talk.0.b")
]);
Shop_AddTalk(Lang_GetString("shop.demo.talk.name.1"),[
	Lang_GetString("shop.demo.talk.1"),
	Lang_GetString("shop.demo.talk.1.b")
]);
Shop_AddTalk(Lang_GetString("shop.demo.talk.name.2"),[
	Lang_GetString("shop.demo.talk.2")
]);
Shop_AddTalk(Lang_GetString("shop.demo.talk.name.3"),[
	Lang_GetString("shop.demo.talk.3")
]);
Shop_AddTalk(Lang_GetString("shop.demo.talk.name.4"),[
	Lang_GetString("shop.demo.talk.4")
]);

if(_geno){
	Shop_ApplyMainTemplate("geno");
	Shop_PatchBuy(3,{state:SHOP_SLOT.OPEN});
	if(Plot_Get(Shop_GetHostShortName()+"_steal",0)!=0){
		Shop_SetMainChoice(1,SHOP_MAIN_ACTION.DIALOG,Lang_GetString("shop.menu.choice.steal"),Lang_GetString("shop.demo.steal.done"));
	}
}
