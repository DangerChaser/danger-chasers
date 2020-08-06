shader_type canvas_item;

uniform vec4 outline_col : hint_color; //Outline color

void fragment() {

vec4 col = texture(TEXTURE,UV);

//Get alpha val of adjacent pixels

vec2 p = TEXTURE_PIXEL_SIZE;

float a = texture(TEXTURE,UV+vec2(p.x,0)).a;

    a += texture(TEXTURE,UV+vec2(-p.x,0)).a;

    a += texture(TEXTURE,UV+vec2(0,p.y)).a;

    a += texture(TEXTURE,UV+vec2(0,-p.y)).a;

//Using found alpha value,

    a = step(a,.5);//Clamp the a value

    col.rgb = mix(outline_col.xyz, col.rgb, col.a);

    col.a = step(a, col.a);

//Get palette color

    COLOR = col;

}