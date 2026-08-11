room_persistent=false;

var z=Storage_GetTempGeneral();

if(room=z.Get(FLAG_TEMP_OLD_PERSISTENT_ROOM,-1)){
	room_restart();
	z.Set(FLAG_TEMP_OLD_PERSISTENT_ROOM,-1)
}