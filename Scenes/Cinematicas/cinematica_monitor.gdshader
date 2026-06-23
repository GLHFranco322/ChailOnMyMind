shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float flicker = 0.9 + sin(TIME * 30.0) * 0.1;

	float scanline = sin(UV.y * 250.0) * 0.08;

	COLOR = tex * flicker - scanline;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
