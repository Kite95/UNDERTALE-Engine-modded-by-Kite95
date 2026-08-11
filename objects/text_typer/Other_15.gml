///@desc Group & Macro
_macro[$ "true"]=true;
_macro[$ "false"]=false;

_macro[$ "DIR_CHAR.UP"]=DIR_CHAR.UP;
_macro[$ "DIR_CHAR.DOWN"]=DIR_CHAR.DOWN;
_macro[$ "DIR_CHAR.LEFT"]=DIR_CHAR.LEFT;
_macro[$ "DIR_CHAR.RIGHT"]=DIR_CHAR.RIGHT;

_macro[$ "FONT.DIALOG"]=0;
_macro[$ "FONT.MENU"]=1;
_macro[$ "FONT.BATTLE"]=2;

_macro[$ "VOICE.NULL"]=-1;
_macro[$ "VOICE.DEFAULT"]=0;
_macro[$ "VOICE.TYPER"]=1;

Lang_BindTyperGroup(0,"dialog");
Lang_BindTyperGroup(1,"menu");
Lang_BindTyperGroup(2,"battle");

_group_voice[0,0]=snd_text_voice_default;
_group_voice[1,0]=snd_text_voice_typer;

// examples:
// _group_voice_interval[1]=3;
// _group_voice_pitch[1]=0.9;
// _group_voice_pitch_random[1]=0.15;
// _group_voice_stop[1]=false;

_group_face[0]=face;