// Phone calls are also items.
// When the player selects a phone item, OnUse is called.
function CustomItem_Phone_TML() : ItemType() constructor{
	function GetName(){
		return "Call Toriel";
	}
	
	function OnUse(inventory,index){
		SFX_Play(snd_phone_call,0,false);
		Dialog_Add("* Dialing...");
		
		// You can check what room it currently is, and display different dialogs.
		Dialog_Add("* ...{pause}{clear}* Nobody picked up.");
		
		Dialog_Start();
	}
}