shader_type spatial;

uniform vec3 base_color;
uniform sampler2D color_variation;
uniform sampler2D height_noise;
uniform int resolution;
uniform vec2 wind;

varying vec3 world_vert;
varying vec3 world_norm;

const float PI = 3.1415926;

float angle_between(vec3 a, vec3 b) {
	return acos(dot(a, b) / (length(a) * length(b)));
}

float sampled_height(vec2 uv) {
	vec2 res_step = vec2(1.0 / float(resolution));
	float height = 0.0;
	vec2 sample_uv = uv;
	for (int i = 0; i < resolution; i++) {
		float sample_height = texture(height_noise, sample_uv).r;
		height = max (height, sample_height);
		sample_uv -= res_step;
	}
	return height;
}

void vertex() {
	VERTEX += vec3(0.0, 0.02, 0.0);
	world_vert = VERTEX;
	world_norm = NORMAL;
}

void fragment() {
	vec3 world_pos = world_vert;
	vec2 uv = world_vert.xz;
	vec3 toward_camera = (-VIEW);
	//toward_camera.z = -toward_camera.z;
	vec3 world_camera = (vec4(toward_camera, 0.0) * INV_CAMERA_MATRIX).xyz;
	vec3 tangent_camera = world_camera - world_norm;
	float y_angle = angle_between(tangent_camera, world_camera);
	
	float height = 0.7 * sampled_height(uv);
	float dist = tan(y_angle) * height;
	//uv = toward_camera.xz;
	uv = uv + dist * height * world_camera.xz;
	//uv = vec2(
	//	floor(100.0 * uv.x) / 100.0,
	//	floor(100.0 * uv.y) / 100.0
	//);
	float value = texture(height_noise, uv).r;
	vec3 coloration = texture(color_variation, uv).rgb;
	value = smoothstep(0.48, 0.6, value);
	ALPHA = value;
	ALBEDO = base_color + 0.35 * (0.25 - coloration);
}