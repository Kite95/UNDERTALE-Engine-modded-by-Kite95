///@desc Hurt
global._inv=Player_GetInvTotal();
SFX_Play(snd_hurt,0,false);
Camera_Shake(2,2,4,4);