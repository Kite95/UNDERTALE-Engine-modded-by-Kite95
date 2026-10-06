visible=false;

repeat(6){
	instance_create_depth(x,y,depth,soul_shard);
}

SFX_Play(snd_break_1,0,false);

alarm[2]=50;
