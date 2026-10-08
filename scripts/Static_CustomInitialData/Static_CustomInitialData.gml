/// Default static.json / general values.
function Static_CustomInitialData(){
	Player_SetName("PLAYER");
	Player_SetFun(0);
	Player_SetLv(1);
	Player_SetHpMax(20);
	Player_SetHp(20);
	Player_SetAtk(10);
	Player_SetAtkItem(0);
	Player_SetDef(10);
	Player_SetDefItem(0);
	Player_SetSpd(4);
	Player_SetSpdItem(0);
	Player_SetInv(40);
	Player_SetInvItem(0);
	Player_SetExp(0);
	Player_SetGold(100);
	Player_SetKills(0);
	Player_SetBattleFightMenuObj(battle_menu_fight_knife);

	var z=Storage_GetStaticGeneral();
	z.Set(FLAG_STATIC_ROOM,"");
	z.Set(FLAG_STATIC_TIME,0);

	var items=Item_GetInventoryItems();
	items.Clear();
	items.Add(ITEM_TOY_KNIFE);
	items.Add(ITEM_FADED_RIBBON);
	items.Add(ITEM_STICK);
	items.Add(ITEM_STICK);
	items.Add(ITEM_FADED_RIBBON);
	items.Add(ITEM_STICK);
	items.Add(ITEM_FADED_RIBBON);
	items.Add(ITEM_STICK);

	var phones=Item_GetInventoryPhones();
	phones.Clear();
	phones.Add(ITEM_PHONE_TML);

	Player_SetItemWeapon(ITEM_STICK);
	Player_SetItemArmor(ITEM_BANDAGE);
}
