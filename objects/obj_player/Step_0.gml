var movement_direction = point_direction(x, y, mouse_x, mouse_y),
	distance_to_mouse = point_distance(x, y, mouse_x, mouse_y);
	
if distance_to_mouse <= movement_speed {
	x = mouse_x;
	y = mouse_y;
} else {	
	var	x_movement = lengthdir_x(movement_speed, movement_direction),
		y_movement = lengthdir_y(movement_speed, movement_direction);
	
	x += x_movement;
	y += y_movement;
}