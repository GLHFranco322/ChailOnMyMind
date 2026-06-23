shader_type canvas_item;

uniform float glitch_amount = 0.0;

void fragment()
{
    vec4 tex = texture(TEXTURE, UV);

    if (glitch_amount > 0.5)
        COLOR = vec4(1.0, 0.0, 0.0, 1.0);
    else
        COLOR = tex;
}
