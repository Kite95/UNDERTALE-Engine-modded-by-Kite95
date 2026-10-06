function Macro_Game() {
	//Anything you want, must be a string.
#macro GAME_NAME "UNDERTALE Engine modded by Kite95"

	//Anything you want, must be a string.
#macro GAME_AUTHOR "Kite95"

	//Anything you want, must be a string.
#macro GAME_VERSION "v0.0.0"

	//Anything you want, must be a string.
	//Can only contain letters, numbers and underscores.
#macro GAME_SAVE_NAME "undertale_engine"

	//true: indented JSON save files; false: compact single-line
#macro GAME_SAVE_INDENT true

	// SAVE_MODE.SINGLE = one slot (file0); SAVE_MODE.TRIPLE = pick slot at save point
#macro GAME_SAVE_DEFAULT SAVE_MODE.TRIPLE

	enum SAVE_MODE{
		SINGLE,
		TRIPLE,
	};

	// true: treat Windows as mobile (touch overlay + official langs only)
#macro GAME_MOBILE_PREVIEW false

	// true: debugger hotkeys and overlays
#macro GAME_DEBUG true

}