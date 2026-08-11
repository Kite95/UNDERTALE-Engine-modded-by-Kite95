// static data is saved when the player uses the save point
function Storage_Custom_Static(storages){
	var s=new Storage(Storage_MakeGetFilePathFunc(true,"static.json"));
	storages.Register("static",s);
	
	// General zone is for common player stats.
	var zGeneral=new StorageZoneStruct();
	// We use general zone a lot. Make a cached variable to make accessing faster.
	global._storage_cache_static_general=zGeneral;
	s.Register("general",zGeneral);

	// Plot zone — all narrative flags (main plot, shop events, room one-shots, etc.)
	var zPlot=new StorageZoneStruct();
	global._storage_cache_static_plot=zPlot;
	s.Register("plot",zPlot);
	
	// Inventories zone saves data for all the registered inventories.
	s.Register("inventories",new StorageZoneInventories(Item_GetInventoryManager()));
	
}

function Storage_GetStatic(){
	return Storage_GetManager().Get("static");
}
function Storage_GetStaticGeneral(){
	return global._storage_cache_static_general;
}
function Storage_GetStaticPlot(){
	return global._storage_cache_static_plot;
}