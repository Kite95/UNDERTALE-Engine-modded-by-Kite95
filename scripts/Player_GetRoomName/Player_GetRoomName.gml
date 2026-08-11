///@arg room
function Player_GetRoomName() {
	var ROOM=argument[0];

	if(!room_exists(ROOM)){
		return "--";
	}

	var name=room_get_name(ROOM);

	var formatted_name=string_replace(name,"room_","");
	formatted_name=string_replace_all(formatted_name,"_",".");

	var lang_key="save."+formatted_name+".room";

	return Lang_GetString(lang_key,formatted_name);
}
