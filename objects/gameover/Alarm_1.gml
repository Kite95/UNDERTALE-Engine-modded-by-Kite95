_inst_text=instance_create_depth(160,315,DEPTH_UI.TEXT,text_typer);
_inst_text.text="{define `NAME` `"+Player_GetName()+"`}{skippable false}{scale 2}{font 0}{gui true}{voice 1}{speed "+string(_dialog_speed)+"}{depth "+string(DEPTH_UI.TEXT)+"}"+Lang_GetString("battle.gameover."+string(irandom(4)))+"{pause}{clear}"+Lang_GetString("battle.gameover.determined")+"{pause}{end}";
