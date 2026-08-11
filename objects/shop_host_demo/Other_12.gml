/// MENU_START — right-side tips / buy-sell-take feedback
var shop_menu=Shop_GetMenu();

if(shop_menu==SHOP_MENU.BUY&&Shop_GetMenuBuy()==SHOP_BUY.MENU){
	var result=Shop_GetBuyResult();
	var take=Shop_IsBuyFree();
	var tip="";
	if(!take){
		tip=Lang_GetString("shop.demo.menu.buy");
		switch(result){
			case SHOP_BUY_RESULT.YES:
				tip=Lang_GetString("shop.demo.menu.buy.yes");
				break;
			case SHOP_BUY_RESULT.NO:
				tip=Lang_GetString("shop.demo.menu.buy.no");
				break;
			case SHOP_BUY_RESULT.NO_MONEY:
				tip=Lang_GetString("shop.demo.menu.buy.nomoney");
				break;
			case SHOP_BUY_RESULT.NO_ROOM:
				tip=Lang_GetString("shop.demo.menu.buy.noroom");
				break;
			case SHOP_BUY_RESULT.UNABLE:
				tip=Lang_GetString("shop.demo.menu.buy.unable");
				break;
			case SHOP_BUY_RESULT.SOLD_OUT:
				tip=Lang_GetString("shop.demo.menu.buy.sellout");
				break;
		}
	}else{
		tip=Lang_GetString("shop.demo.menu.take");
		switch(result){
			case SHOP_BUY_RESULT.YES:
				tip=Lang_GetString("shop.demo.menu.take.yes");
				break;
			case SHOP_BUY_RESULT.NO:
				tip=Lang_GetString("shop.demo.menu.take.no");
				break;
			case SHOP_BUY_RESULT.NO_ROOM:
				tip=Lang_GetString("shop.demo.menu.take.noroom");
				break;
			case SHOP_BUY_RESULT.UNABLE:
				tip=Lang_GetString("shop.demo.menu.take.unable");
				break;
			case SHOP_BUY_RESULT.SOLD_OUT:
				tip=Lang_GetString("shop.demo.menu.take.sellout");
				break;
		}
	}
	if(tip!="")Shop_SetRightDialog(tip);
	Shop_SetBuyResult(SHOP_BUY_RESULT.NULL);
}

if(shop_menu==SHOP_MENU.TALK){
	Shop_SetRightDialog(Lang_GetString("shop.demo.menu.talk"));
}

if(shop_menu==SHOP_MENU.SELL&&Shop_GetMenuSell()==SHOP_SELL.MENU){
	var sell_result=Shop_GetSellResult();
	if(sell_result==SHOP_SELL_RESULT.UNABLE){
		var sell_tip=Lang_GetString("shop.demo.menu.sell.unable");
		if(sell_tip!="")Shop_SetRightDialog(sell_tip);
	}
	Shop_SetSellResult(SHOP_SELL_RESULT.NULL);
}
