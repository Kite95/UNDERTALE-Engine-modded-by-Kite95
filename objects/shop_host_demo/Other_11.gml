/// SHOP_START
if(_geno){
	Shop_SetMenuDialog(Lang_GetString("shop.demo.menu.main.geno."+string(irandom(1))));
}else{
	Shop_SetMenuDialog(Lang_GetString("shop.demo.menu.main."+string(irandom(2))));
}
