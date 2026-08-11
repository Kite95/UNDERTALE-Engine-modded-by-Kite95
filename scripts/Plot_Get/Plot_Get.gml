///@arg key
///@arg default*
function Plot_Get(){
	var KEY=argument[0];
	var DEF=0;
	if(argument_count>=2)DEF=argument[1];
	return Storage_GetStaticPlot().Get(KEY,DEF);
}
