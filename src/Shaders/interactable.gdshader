shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D albedoTexture : source_color, filter_nearest;
uniform sampler2D emissionTexture : source_color, filter_nearest;
uniform vec4 emissionColor : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float emissionIntensity;
uniform vec4 pulseColor : source_color = vec4(1.0f, 1.0f, 1.0f, 1.0f);
uniform float timeScale = 1.0f;

void vertex() {
}

void fragment() {
	ALBEDO = texture(albedoTexture, UV).rgb;
	EMISSION = emissionIntensity * emissionColor.rgb * texture(emissionTexture, UV).rgb + (pulseColor * 0.5 * (1.0 + sin(TIME * timeScale)*sin(TIME * timeScale))).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
