///@description Create Event of obj_map
x = 16;
y = 16;
scale = 0.12;
width = round(room_width * scale);
height = round(room_height * scale);
objects_to_draw = [
	obj_solid, c_dkgray,
	obj_player, c_maroon,
	obj_item, c_yellow
]
background_color = c_gray;