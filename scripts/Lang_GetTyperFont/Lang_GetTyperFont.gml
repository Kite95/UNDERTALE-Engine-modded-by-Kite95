///@arg group
///@arg face*
///@arg default*
function Lang_GetTyperFont() {
	var GROUP=argument[0];
	var FACE="ascii";
	var DEF=-1;
	if(argument_count>=2){
		FACE=argument[1];
	}
	if(argument_count>=3){
		DEF=argument[2];
	}

	var KEY=Lang_GetTyper(string(GROUP)+"."+string(FACE)+".font","");
	if(!is_string(KEY)||KEY==""){
		return DEF;
	}
	return Lang_GetFont(KEY,DEF);
}
