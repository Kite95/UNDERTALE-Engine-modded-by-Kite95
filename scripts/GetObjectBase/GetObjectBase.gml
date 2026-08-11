//@arg object
function GetObjectBase() {
	var OBJ=argument[0];
	
	if(!object_exists(OBJ)){
		return -1;
	}
	
	var last;
	do{
		last=OBJ;
		OBJ=object_get_parent(OBJ);
	}until(OBJ==-100);
	
	return last;
}