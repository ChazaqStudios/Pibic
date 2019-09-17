shader_type spatial;
render_mode blend_mix;

uniform vec4 main_color : hint_color;
uniform float specular : hint_range(0.0, 1.0);
uniform float roughness : hint_range(0.0, 1.0);
uniform float metallic : hint_range(0.0, 1.0);
uniform float speed : hint_range(0.0, 0.1);
uniform float scale : hint_range(0.0, 10.0);

uniform sampler2D normal_map : hint_normal;
uniform sampler2D normal2 : hint_normal;

void fragment(){
	vec2 uv_1 = vec2(UV.x + (TIME * speed), UV.y);
	vec2 uv_2 = vec2(UV.x + (TIME * -speed), UV.y);
	ALBEDO = main_color.rgb;
	SPECULAR = specular;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	NORMALMAP = texture(normal_map, uv_1 * scale).xyz * texture(normal2, uv_2 * scale).xyz;
	ALPHA = main_color.a;
}