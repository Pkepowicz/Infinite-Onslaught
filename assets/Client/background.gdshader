shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
const float speed_x = 0.02;
const float speed_y = 0.01;

void fragment() {
	vec2 new_uv = vec2(UV.x + TIME * speed_x, UV.y + TIME * speed_y);
	COLOR = texture(noise, new_uv) * vec4(0.008, 0.016, 0.162, 0.82);
}
