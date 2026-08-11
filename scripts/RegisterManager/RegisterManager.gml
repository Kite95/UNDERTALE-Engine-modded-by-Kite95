function RegisterManager() constructor{
	contents={};
	function Register(id, content){
		if(string_length(id)==0){
			show_error("id cannot be empty!",true);
			return false;
		}
		if(Contains(id)){
			show_error("id "+string(id)+" has already been registered!",true);
			return false;
		}
		variable_struct_set(contents,id,content);
		return true;
	}
	function GetOrUndefined(id){
		if(!Contains(id)){
			return undefined;
		}
		return variable_struct_get(contents,id);
	}
	function Get(id){
		if(!Contains(id)){
			show_error("id "+string(id)+" not found!",true);
			return undefined;
		}
		return variable_struct_get(contents,id);
	}
	function Contains(id){
		return string_length(id)!=0 && variable_struct_exists(contents,id);
	}
	function GetIds(){
		return variable_struct_get_names(contents);
	}
}