function Macro_Shop() {
	enum SHOP_STATE{
		MENU,
		DIALOG
	};

	enum SHOP_MENU{
		MENU,
		BUY,
		SELL,
		TALK,
		EXIT
	};

	/// Main-menu slot actions. TAKE = BUY + free; STEAL/READ = DIALOG (effects via typer cmds).
	enum SHOP_MAIN_ACTION{
		BUY,
		SELL,
		TALK,
		EXIT,
		DIALOG
	};

	enum SHOP_BUY{
		MENU,
		CONFIRM
	};

	enum SHOP_BUY_RESULT{
		NULL,
		YES,
		NO,
		NO_MONEY,
		NO_ROOM,
		UNABLE,
		SOLD_OUT
	};

	enum SHOP_SLOT{
		OPEN=0,
		LOCKED=1,
		SOLD_OUT=2
	};

	enum SHOP_SELL{
		MENU,
		CONFIRM
	};

	enum SHOP_SELL_RESULT{
		NULL,
		YES,
		NO,
		UNABLE
	};

	enum SHOP_HOST_EVENT{
		INIT,
		SHOP_START,
		MENU_START,
		MENU_SWITCH,
		CHOICE_SWITCH,
		CONFIRM,
		DIALOG_START,
		DIALOG_END
	};

	enum SHOP_MENU_LIST_LAYOUT{
		VERTICAL,
		PAGE
	};

	//VERTICAL: window follows the cursor and stops at the ends. PAGE: left/right turns pages.
	#macro SHOP_MENU_LIST_LAYOUT_CURRENT SHOP_MENU_LIST_LAYOUT.PAGE

	//Buy and talk lists show at most four pages.
	#macro SHOP_MENU_LIST_PAGE_MAX 4
}
