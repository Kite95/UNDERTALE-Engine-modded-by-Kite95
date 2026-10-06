if(!GAME_DEBUG){
	exit;
}
Debugger_ListUpdateLayout(id);

var f=Lang_GetFont("determination_sans",font_mars_needs_cunnilingus);
draw_set_font(f);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var scale=_layout_scale;
var gui_h=display_get_gui_height();
var count=array_length(_rows);
var line_full=_layout_line_full;
var pad_l=_layout_pad_l;
var pad_r=_layout_pad_r;
var item_indent=_layout_item_indent;
var title=title_text;

var panel_x=0;
var panel_y=0;
var panel_w=_layout_panel_w;
var searchbar_top=_layout_searchbar_top;
var search_bar_h=_layout_search_bar_h;
var list_top=_layout_list_top;
var panel_bottom=gui_h;

draw_set_color(c_black);
draw_set_alpha(0.55);
draw_rectangle(panel_x,panel_y,panel_x+panel_w,panel_bottom,false);
draw_set_alpha(1);

var tx=panel_x+pad_l;
var bar_w=panel_w-pad_l-pad_r;

var list_w_full=max(1,floor((panel_w-pad_l-pad_r)/scale));
var list_h_full=_visible_rows*line_full;

if(!surface_exists(_list_surf)||surface_get_width(_list_surf)!=list_w_full||surface_get_height(_list_surf)!=list_h_full){
	if(surface_exists(_list_surf)){
		surface_free(_list_surf);
	}
	_list_surf=surface_create(list_w_full,list_h_full);
}

surface_set_target(_list_surf);
draw_clear_alpha(c_black,0);
draw_set_font(f);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var start_i=floor(_scroll);
var scroll_frac=_scroll-start_i;
var draw_y=-scroll_frac*line_full;

var sel_text="";
var sel_tw=0;

for(var i=start_i;i<count&&i<=start_i+_visible_rows+1;i+=1){
	if(i<0){
		continue;
	}
	var row=_rows[i];
	var row_y=draw_y+(i-start_i)*line_full;
	var text="";

	if(row.kind=="header"){
		var hcol=Debugger_ListCategoryColor(row.label);
		if(variable_struct_exists(row,"color")){
			hcol=row.color;
		}
		Debugger_ListDrawHeader(0,row_y,row.label,scale,hcol);
	}else if(row.kind=="line"){
		draw_set_color(c_ltgray);
		text=row.label;
		draw_text(0,row_y,text);
	}else{
		text=row.label;
		var ix=item_indent;
		if(i==_selection){
			sel_text=text;
			sel_tw=string_width(text);
		}
		if(search_enabled&&_search_input!=""){
			var pos=string_pos(string_lower(_search_input),string_lower(text));
			if(pos>0){
				var pre=string_copy(text,1,pos-1);
				var match_w=string_width(string_copy(text,pos,string_length(_search_input)));
				var mx=ix+string_width(pre);
				draw_set_color(c_white);
				draw_set_alpha(0.2);
				draw_rectangle(mx,row_y-1,mx+match_w,row_y+line_full-3,false);
				draw_set_alpha(1);
			}
		}
		draw_set_color(c_white);
		draw_text(ix,row_y,text);
	}
}

if(sel_text!=""&&_rows[_selection].kind=="item"&&!_search_mode){
	var ix=item_indent;
	var text_h=string_height("A");
	var box_y=_sel_y+round(text_h*300/1200)-3;
	draw_set_color(c_white);
	draw_set_alpha(0.7);
	draw_rectangle(ix-2,box_y,ix+sel_tw+4,box_y+max(1,round(text_h*675/1200))+5,false);
	draw_set_alpha(1);
}
surface_reset_target();

draw_surface_ext(_list_surf,tx,list_top,scale,scale,0,c_white,1);

if(search_enabled){
	var bar_text=_search_input;
	var placeholder=(string_length(bar_text)==0);
	var searchbar_height=search_bar_h;
	var search_ix=tx+item_indent;
	var box_x=tx;
	var searchbar_width=bar_w;
	var search_box_inset=4;
	var box_outer_y=panel_y+searchbar_top;
	var box_y=box_outer_y+search_box_inset;
	var box_h=searchbar_height-search_box_inset*2;
	var text_h=string_height("A");
	var text_y=box_y+(box_h-text_h)*0.5;

	draw_set_color(c_dkgray);
	draw_set_alpha(0.45);
	draw_rectangle(box_x,box_y,box_x+searchbar_width,box_y+box_h,false);
	draw_set_alpha(1);

	if(!placeholder){
		draw_set_color(c_white);
		draw_text(search_ix,text_y,bar_text);
	}else if(!_search_mode){
		draw_set_color(c_gray);
		draw_text(search_ix,text_y,Debugger_ListSearchLabel());
	}

	if(_search_mode&&((_search_cursor_timer div 10) mod 2)==0){
		var cx=search_ix+(placeholder?0:string_width(bar_text)+1);
		var caret_h=max(1,round(text_h*675/1200));
		var cy1=text_y+round(text_h*300/1200);
		var cy2=cy1+caret_h;
		draw_set_color(c_white);
		draw_rectangle(cx,cy1,cx+1,cy2,false);
	}
}else{
	draw_set_color(c_ltgray);
	draw_text_transformed(tx,panel_y+2,title,scale,scale,0);
}

draw_set_color(c_white);
draw_set_alpha(1);
