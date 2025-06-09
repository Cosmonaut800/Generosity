shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D albedoTexture : source_color, filter_nearest;
uniform sampler2D emissionTexture : source_color, filter_nearest;
uniform vec4 emissionColor : source_color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
uniform float emissionIntensity = 1.0f;
uniform vec4 pulseColor : source_color = vec4(1.0f, 1.0f, 1.0f, 1.0f);
uniform float timeScale = 1.0f;

void vertex() {
}

void fragment() {
	//vec4 col = texture(albedoTexture, UV);
	/*if (col.r <= 0.0031308) col.r = clamp(col.r*12.92, 0.0f, 1.0f);
	else col.r = clamp(1.055*pow(col.r,1.0f/2.4f)-0.055, 0.0f, 1.0f);

	if (col.g <= 0.0031308) col.g = clamp(col.g*12.92, 0.0f, 1.0f);
	else col.g = clamp(1.055*pow(col.g,1.0f/2.4f)-0.055, 0.0f, 1.0f);

	if (col.b <= 0.0031308) col.b = clamp(col.b*12.92, 0.0f, 1.0f);
	else col.b = clamp(1.055*pow(col.b,1.0f/2.4f)-0.055, 0.0f, 1.0f);*/

	ALBEDO = texture(albedoTexture, UV).rgb;
	EMISSION = emissionIntensity * emissionColor.rgb * texture(emissionTexture, UV).rgb + (pulseColor * 0.5 * (timeScale + sin(TIME * timeScale)*sin(TIME * timeScale))).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
