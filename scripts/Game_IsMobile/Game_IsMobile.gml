function Game_IsMobile() {
	return (os_type==os_android||os_type==os_ios||GAME_MOBILE_PREVIEW);
}
