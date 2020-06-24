shader_type canvas_item;

uniform vec2 direction = vec2(1.0,0.0);
uniform float scroll_speed = 0.05;

void fragment(){
	vec2 shifteduv = UV;
	shifteduv += -direction * TIME * scroll_speed;
	vec2 move = -direction * TIME * scroll_speed;
	vec4 color = texture(TEXTURE, shifteduv);
	COLOR = color;   
}