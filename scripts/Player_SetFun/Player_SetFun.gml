///@arg fun
function Player_SetFun(fun) {
	Storage_GetStaticGeneral().Set(FLAG_STATIC_FUN,floor(fun));
}