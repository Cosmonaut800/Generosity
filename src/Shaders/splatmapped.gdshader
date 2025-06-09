shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D background : source_color, filter_nearest;
uniform sampler2D detail : source_color, filter_nearest;
uniform sampler2D splatmap : repeat_disable;
varying vec2 worldUV;
uniform vec2 SplatScale = vec2(1.0f, 1.0f);
uniform vec2 SplatOffset = vec2(0.0f, 0.0f);

void vertex() {
	worldUV = VERTEX.xz;
}

void fragment() {
	ALBEDO = mix(texture(background,UV).rgb, texture(detail, UV).rgb, texture(splatmap, (worldUV-SplatOffset)/SplatScale).r);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
