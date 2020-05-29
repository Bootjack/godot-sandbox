shader_type spatial;

uniform float layer_height;
uniform sampler2D alpha_noise;
uniform sampler2D height_noise;

varying float height;

void vertex() {
	height = texture(height_noise, UV).r;
	VERTEX.y += 2.0 * height * layer_height;
}

void fragment() {
	float alpha = texture(alpha_noise, UV).r;
	ALPHA = smoothstep(0.5, 0.6, alpha);
	ALBEDO = vec3(alpha * layer_height, 10.0 * alpha * layer_height, 0.0);
}
