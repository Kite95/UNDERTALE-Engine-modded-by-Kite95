///@arg item_choice
///@arg call_event*
function Battle_SetMenuChoiceItem() {
	var SLOT=argument[0];
	var CALL=true;
	if(argument_count>=2){
		CALL=argument[1];
	}

	var items=Item_GetInventoryItems();
	var count=items.GetCount();
	if(SLOT<count){
		battle._menu_choice_item=SLOT;
		var text="";
		if(BATTLE_MENU_ITEM_LAYOUT_CURRENT==BATTLE_MENU_ITEM_LAYOUT.PAGE){
			var page=SLOT div 4;
			var base=page*4;
			battle._menu_choice_item_first=base;
			var text2="";
			if(base<count){
				text+=Battle_GetMenuPrefix()+items.GetItemName(base);
			}
			text+="\n";
			if(base+2<count){
				text+=Battle_GetMenuPrefix()+items.GetItemName(base+2);
			}
			if(base+1<count){
				text2+=Battle_GetMenuPrefix()+items.GetItemName(base+1);
			}
			text2+="\n";
			if(base+3<count){
				text2+=Battle_GetMenuPrefix()+items.GetItemName(base+3);
			}
			text2+="\n   {define `PAGE` "+string(page+1)+"}"+Lang_GetString("battle.menu.item.page");
			Battle_SetDialog(text,true);
			Battle_SetDialog(text2,true,true);
		}else{
			while(SLOT>=battle._menu_choice_item_first+3){
				battle._menu_choice_item_first+=1;
			}
			while(SLOT<battle._menu_choice_item_first){
				battle._menu_choice_item_first-=1;
			}
		
			var proc=battle._menu_choice_item_first;
			repeat(min(3,count)){
				text+=Battle_GetMenuPrefix()+items.GetItemName(proc)+"\n";
				proc+=1;
			}
			Battle_SetDialog(text,true);
		}
				
		if(CALL){
			Battle_CallEnemyEvent(BATTLE_ENEMY_EVENT.MENU_CHOICE_SWITCH);
		}
	
		return true;
	}else{
		return false;
	}


}

/// 2x2 pages. Eight items land where the old two-page branch did.
///@arg slot
///@arg count
function Battle_StepItemPageChoice(){
	var SLOT=argument[0];
	var COUNT=argument[1];
	var page=SLOT div 4;
	var cell=SLOT mod 4;
	var col=cell mod 2;
	var row=cell div 2;
	var on_page=page*4+4;
	var next=SLOT;

	if(Input_IsPressed(INPUT.UP)){
		if(row==1){
			next=SLOT-2;
		}else if(SLOT+2<COUNT&&SLOT+2<on_page){
			next=SLOT+2;
		}
	}else if(Input_IsPressed(INPUT.DOWN)){
		if(row==0){
			if(SLOT+2<COUNT&&SLOT+2<on_page){
				next=SLOT+2;
			}
		}else{
			next=SLOT-2;
		}
	}else if(Input_IsPressed(INPUT.LEFT)){
		if(col==1){
			next=SLOT-1;
		}else if(page>0){
			next=SLOT-3;
		}else{
			var last=(ceil(COUNT/4)-1)*4+row*2;
			if(last+1<COUNT){
				next=last+1;
			}else if(last<COUNT&&last!=SLOT){
				next=last;
			}else if(row*2+1<COUNT){
				next=row*2+1;
			}
		}
	}else if(Input_IsPressed(INPUT.RIGHT)){
		if(col==0){
			if(SLOT+1<COUNT&&SLOT+1<on_page){
				next=SLOT+1;
			}else if(page>0){
				next=row*2;
			}
		}else{
			var ahead=(page+1)*4+row*2;
			next=(ahead<COUNT ? ahead : row*2);
		}
	}
	return next;
}