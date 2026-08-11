///@arg text
function Json_EscapeString() {
	var s=string(argument[0]);
	var out="";
	var len=string_length(s);
	var i=0;
	var c="";
	for(i=1;i<=len;i+=1){
		c=string_char_at(s,i);
		if(c=="\\"){
			out+="\\\\";
		}else if(c=="\""){
			out+="\\\"";
		}else if(c=="\n"){
			out+="\\n";
		}else if(c=="\r"){
			out+="\\r";
		}else if(c=="\t"){
			out+="\\t";
		}else{
			out+=c;
		}
	}
	return out;
}
