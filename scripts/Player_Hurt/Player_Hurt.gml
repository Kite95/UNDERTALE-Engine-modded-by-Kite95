///@arg damage
function Player_Hurt(damage) {
	if(damage<0){
		return Player_Heal(-damage);
	}
	if(damage>0){
		if(GAME_DEBUG&&global.debug_invincible){
			return true;
		}
		var hp=max(0,Player_GetHp-damage);
		Player_SetHp(hp);
	}
	return true;
}
