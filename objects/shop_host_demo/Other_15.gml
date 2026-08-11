/// CONFIRM — host refuses to buy stick after sale
if(Shop_GetMenu()==SHOP_MENU.SELL){
	var sell_result=Shop_GetSellResult();
	if(sell_result==SHOP_SELL_RESULT.YES){
		var li=Shop_GetLastSellItem();
		if(li==ITEM_STICK){
			var price=Shop_GetItemSellPrice(li);
			Dialog_Add(Lang_GetString("shop.demo.sell.stick.refuse"));
			Item_GetInventoryItems().Insert(0,li);
			Player_SetGold(Player_GetGold()-price);
			shop._sell_thanks-=1;
			audio_stop_sound(snd_item_equip);
		}
	}
	Shop_SetSellResult(SHOP_SELL_RESULT.NULL);
}
