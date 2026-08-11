// dynamic data is used for data that won't revert when player loads.
// For example, you met Flowey and didn't save the game. Flowey will have
// a different dialog when you met him again at the same place.
// !! To achieve this, you need to save the dynamic data after changing the values.
//    Use Storage_SaveDynamic
function Storage_Custom_Dynamic(storages){
	var s=new Storage(Storage_MakeGetFilePathFunc(true,"dynamic.json"));
	storages.Register("dynamic",s);
		
	global._storage_cache_dynamic_general=new StorageZoneStruct();
	s.Register("general",global._storage_cache_dynamic_general);
}

function Storage_GetDynamic(){
	return Storage_GetManager().Get("dynamic");
}
function Storage_GetDynamicGeneral(){
	return global._storage_cache_dynamic_general
}
function Storage_SaveDynamic(key,value){
	var s=Storage_GetDynamic();
	var z=Storage_GetDynamicGeneral();
    z.Set(key,value);
	s.SaveToFile();
}
function Storage_LoadDynamic(){
	var s=Storage_GetDynamic();
	s.LoadFromFile();
}
