shader_type spatial;
render_mode unshaded, blend_mix, shadows_disabled;

uniform sampler3D noise;
uniform sampler2D curve: repeat_disable;
uniform float scale = 1.0f;
uniform vec3 offset = vec3(0.0f);

float randf(float ofs)
{
	return fract(sin(dot(vec2(ofs, ofs), vec2(12.9898, 4.1414))) * 43758.5453);
}

float smin(float d1, float d2, float k)
{
	float h = clamp(0.5f + 0.5f*(d2-d1)/k, 0.0f, 1.0f);
	return mix(d2, d1, h) - k*h*(1.0f-h);
}

float sdSphere(vec3 p, float s)
{
	return length(p) - s;
}

float sdBox(vec3 p, vec3 b)
{
	vec3 q = abs(p) - b;
	return length(max(q, 0.0f)) + min(max(q.x, max(q.y, q.z)), 0.0f);
}

//Distance functions
float map(vec3 p, vec3 basePosition)
{
	float atten = clamp(1.0f - pow(distance(scale*p, scale*(basePosition + offset)), 8.0f), 0.0f, 1.0f);
	atten *= clamp(scale*(basePosition.y+offset.y) - scale*p.y + 0.6f, 0.0f, 1.0f) * 0.5f - distance(scale*p.xz, scale*(basePosition.xz+offset.xz));
	
	float result = texture(noise, scale*p*2.0f - scale*(basePosition+offset)*2.0f).g;
	result *= atten;
	result += atten / 5.0f;
	
	return result;
}
//Thanks to Kishimisu on YouTube for explaining this implementation of raymarching!
void fragment() {
	vec3 ro = CAMERA_POSITION_WORLD; //ray origin
	vec3 rd = (INV_VIEW_MATRIX * vec4(-VIEW, 0.0f)).xyz; //ray direction
	float val = 0.0f;
	vec4 col = vec4(0.0f);
	float iter = 0.0f;
	float t = 0.0f; //total distance travelled
	float dist = distance(ro, NODE_POSITION_WORLD);
	
	ro = ro + (dist - 0.25f) * rd;
	//Raymarching
	for (int i = 0; i < 50; i++)
	{
		iter += 1.0f;
		vec3 p = ro + rd * t; //position along the ray

		float d = map(p, NODE_POSITION_WORLD); //current distance to the scene
		
		if (d > 0.1f)
		{
			vec4 c = vec4(texture(curve, vec2(d, 0.5f)).rgb, d);
			c.a *= 0.6; //Change this line
			c.rgb *= c.a;
			col += c * (1.0 - col.a);
		}

		t += 0.01; //march the ray
		//col = texture(curve, vec2(1.0f - col.g, 0.5f));
	}
	//col = mix(vec3(1.0f, 0.3f, 0.0f), vec3(0.1f, 0.0f, 0.1f), vec3(clamp(t / 3.0f, 0.0f, 1.0f)));

	ALBEDO = col.rgb;
	ALPHA = col.a;
}