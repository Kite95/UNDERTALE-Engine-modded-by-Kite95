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

Typer_BindGroup(0,"dialog");
Typer_BindGroup(1,"menu");
Typer_BindGroup(2,"battle");

// examples:
// Typer_BindGroup(3,"sans",font_sans);
// Typer_BindGroup(3,"sans",font_sans,font_sans_cn);
// Typer_BindGroup(3,"sans",{
//	ascii:{font:font_sans,scale:1,space_x:0},
//	other:{font:font_sans_cn,scale:1,space_x:1},
//	space_y:2
// });

Typer_BindVoice(0,snd_text_voice_default);
Typer_BindVoice(1,snd_text_voice_typer);

// examples:
// Typer_BindVoice(4,{sounds:[snd_text_voice_sans],stop:false});
// Typer_BindVoice(2,{sounds:[snd_a,snd_b],pitch:0.9,pitch_random:0.15,interval:3});

_group_face[0]=face;