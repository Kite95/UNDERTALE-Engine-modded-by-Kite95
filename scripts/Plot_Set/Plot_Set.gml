///@arg key
///@arg value
function Plot_Set(){
	Storage_GetStaticPlot().Set(argument[0],argument[1]);
	return true;
}
