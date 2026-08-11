///@arg json_val
///@arg indent_level
function Json_IndentEncode() {
	var _val=argument[0];
	var _level=argument[1];
	var _pad="  ";
	var _ind="";
	var _ind1="";
	var _i=0;
	for(_i=0;_i<_level;_i+=1){
		_ind+=_pad;
	}
	for(_i=0;_i<_level+1;_i+=1){
		_ind1+=_pad;
	}

	if(is_undefined(_val)){
		return "null";
	}
	if(is_bool(_val)){
		return _val ? "true" : "false";
	}
	if(is_string(_val)){
		return "\""+Json_EscapeString(_val)+"\"";
	}
	if(is_real(_val)){
		if(_val==floor(_val)){
			return string(floor(_val));
		}
		return string(_val);
	}
	if(is_array(_val)){
		var _alen=array_length(_val);
		if(_alen<=0){
			return "[]";
		}
		var _alines="";
		for(_i=0;_i<_alen;_i+=1){
			if(_i>0){
				_alines+=",\n";
			}
			_alines+=_ind1+Json_IndentEncode(_val[_i],_level+1);
		}
		return "[\n"+_alines+"\n"+_ind+"]";
	}
	if(is_struct(_val)){
		var _names=variable_struct_get_names(_val);
		var _nlen=array_length(_names);
		if(_nlen<=0){
			return "{}";
		}
		var _slines="";
		for(_i=0;_i<_nlen;_i+=1){
			var _key=_names[_i];
			if(_i>0){
				_slines+=",\n";
			}
			_slines+=_ind1+"\""+Json_EscapeString(_key)+"\": "+Json_IndentEncode(_val[$ _key],_level+1);
		}
		return "{\n"+_slines+"\n"+_ind+"}";
	}

	return json_stringify(_val);
}
