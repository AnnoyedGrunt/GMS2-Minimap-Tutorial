# Automatic Map Tutorial for GameMaker: Studio 2
### Summary
In this tutorial we will explore specific line of solutions regarding the drawing of a minimalistic map. We will do our best to make the map work with the minimum amount of setup in order to create a reusable object that can be plopped down in most projects and, how Todd Howard would put it, *just work*.

![screenshot](https://i.imgur.com/Y9BhAh0.png)

### Preface
This tutorial is aimed at advanced beginners who already know the basics of the GameMaker: Studio 2 engine and its language. You should understand the difference between objects and instances, the concept of variables and arrays, as well as the common flow control instructions *if statement* and *for loop*,

Throughout this tutorial we will approach the concepts of coordinate systems, translation of elements among them, and how they relate to the Draw GUI event. We will also explore the concept of collision masks and bounding boxes.

### The Project
The project features a single room with a player controller `obj_player` and a number of `obj_item` instances scattered throughout the place and separated by `obj_solid` instances acting as walls. The player can pick up (destroy) the coins by touching them.
We don’t place `obj_map` directly but rather let our  `obj_player` instantiate it. This is a personal preference, and the map would work just the same if placed directly.

### Fundamentals: Bounding Boxes
When adding sprites to GameMaker: Studio 2, we have the option to specify a *mask* for our sprite which defines its collision area. In a platform game, for example, we may decide to give power-ups a mask that covers the entire sprite or even a larger area so that they're easier to pick up, or do the same for enemies so they’re easier to hit, while also making their attacks have smaller masks that make them easier to dodge. 
Masks can have different shapes, but regardless of what their shape is they can always be enclosed by a rectangle. Said rectangle is called the *bounding box* and GameMaker: Studio 2 gives us four variables that tell us where it is:

```
bbox_left
bbox_right
bbox_top
bbox_bottom
```

These are similar to the `x` and `y` variables, telling us where the bounding box is *in the room*. Since it is likely that the bounding boxes of your instances roughly if not perfectly match their appearance, we will employ them in the drawing of our map.

### Fundamentals: The Draw GUI Event
In GameMaker: Studio 2, drawing a sprite in position (0, 0) places it at the top-left of the room. If we increase the x and y coordinate, our sprite will move to the right and bottom of the room. If we move our view around, the sprite will remain in place, going out of view if we move away.

If we, however, place our code in the `Draw GUI` event, we see that the sprite will appear on the top-left of the screen. Even if we move our view around, our sprite will follow it. This means that while drawing in the `Draw GUI` event, we are employing a separate coordinate system, whose (0, 0) point is always equal to the top left of the screen.

Furthermore, we will not simply draw the map at position (0, 0) of the GUI, but we will offset it by a further amount: the coordinates of the map itself.

![explanation](https://i.imgur.com/QRuZIdR.png)

### Getting Started
Now that we’ve covered the basics, we can begin setting up our map object `obj_map`.

```
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
```

`x` and `y`, as usual, refer to where the instance is, but since we’re going to draw using the Draw GUI event the map will be drawn at 32 pixels away from the left and top of the screen, rather than 32 pixels away from the left and top of the room. Even when we move around, the map will remain in place.
`scale`, as the name implies, represents the scaling that will be applied to our map. A scaling of 0.12 makes the map about ~1/100 of the size of the room, as both the width and height of the map will be a little bit more than 1/10 of their original size.
`width` and `height` are calculated depending on the scale and we’ll use them later to add a background to our map.
`objects_to_draw` contains all the object types that should appear in our map, as well as the associated color. We make sure to specify them in this specific order, creating couples of (object index, color). Notice how we place each couple on its own line to make this concept clearer.
`background_color` as the name implies, this will be the color of the map’s background.

### Let’s get to it: Drawing the map!

```
//Drawing the Background
draw_set_color(background_color);
draw_rectangle(x, y, x + width, y + height, false);

//Drawing Instances
for(var i = 0; i < array_length_1d(objects_to_draw); i += 2) {
	var map_object_index = objects_to_draw[i],
		map_object_color = objects_to_draw[i + 1];
	
	draw_set_color(map_object_color);
	
	for(var j = 0; j < instance_number(map_object_index); j++) {
		var instance = instance_find(map_object_index, j),
			current_left = instance.bbox_left * scale,
			current_top = instance.bbox_top * scale,
			current_right = instance.bbox_right * scale,
			current_bottom = instance.bbox_bottom * scale;

		draw_rectangle(x + current_left, x + current_top, x + current_right, x + current_bottom, false);
	}
}
```

This is the final result of the draw event.
Let’s examine it, step by step:

```
//Drawing the Background
draw_set_color(background_color);
draw_rectangle(x, y, x + width, y + height, false);
```

This part is fairly straightforward: as the comment implies, we’re just drawing a background to make the map a little nicer.

```
for(var i = 0; i < array_length_1d(objects_to_draw); i += 2) {
	...
}
```

We iterate over the list of `objects_to_draw`. Notice how instead of increasing our index variable `i` by one, we increase it by two. This is because our array is built on couples of object index - color values.

```
var map_object_index = objects_to_draw[i],
		map_object_color = objects_to_draw[i + 1];
	
	draw_set_color(map_object_color);
```

The aforementioned fact makes itself clear as we unwrap the couple into two variables, and set our color. We make sure to set the color outside the inner for loop: it would work the same if we put it inside, but it would result in useless, excessive function calls.

```
for(var j = 0; j < instance_number(map_object_index); j++) {
		var instance = instance_find(map_object_index, j),
		...
	}
}
```

The inner loop is quite simple: we get the number of instances through `instance_number(object index)` and we iterate over each of them, finding the current instance thanks to `instance_find(object index, instance index)`.

```
var instance = instance_find(map_object_index, j),
			current_left = instance.bbox_left * scale,
			current_top = instance.bbox_top * scale,
			current_right = instance.bbox_right * scale,
			current_bottom = instance.bbox_bottom * scale;
```

Once we have the id of the current instance saved in `instance`, we can find its bounding box and convert it by multiplying it with the our `scale`.

```
draw_rectangle(x + current_left, y + current_top, x + current_right, y + current_bottom, false);
```

Finally, we have all the components we need to draw our rectangle. Notice how we shift the converted bounding box values by the map’s coordinates. If we didn’t, the map would still be drawn, but it would always be stuck at the top left corner of the GUI.

### Afterword
The tutorial is done! Your map should work fine now, but this doesn't mean there are no improvements that could be made. Using bounding boxes made our job very simple, but it has its own pitfalls. We are also limited to colored rectangles. Feel free to tinker with the code as provided, and if I have the chance I will create a follow-up tutorial with possible improvements.

Thank you for reading, and have fun learning!

[![Donation Banner](https://i.imgur.com/4J98b5X.png)](https:///www.paypal.me/ratontaro)
[![Kenney Banner](https://i.imgur.com/usJfRFD.png)](https://www.kenney.nl/)
