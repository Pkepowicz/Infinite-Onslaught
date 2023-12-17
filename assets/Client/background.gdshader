shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
const float speed_x = 0.02;
const float speed_y = 0.01;

void fragment() {
	COLOR = vec4(0,0,0,0.8);
}
