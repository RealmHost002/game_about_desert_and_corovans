shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
uniform vec2 death_zone1;
uniform vec2 death_zone2;
//uniform sampler2D noize_tex;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	
//	vec2 world_pos = ((PROJECTION_MATRIX * WORLD_MATRIX) * vec4(VERTEX, 1.0) * inverse(PROJECTION_MATRIX)).xy;
//	vec4 u = texture(noize_tex, world_pos);
//	VERTEX.y += u.r * 1.0;
}




void fragment() {
	vec2 base_uv = UV - 0.5;
	float b = 1.27 + 3.14;
	base_uv *= mat2(vec2(cos(b), sin(b)), vec2(-sin(b), cos(b)));
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	float a = atan(base_uv.y, base_uv.x);
	if (a > death_zone1.x && a < death_zone1.y){
		albedo_tex.a = 0.0;
		}
	if (a > death_zone2.x && a < death_zone2.y){
		albedo_tex.a = 0.0;
		}
	ALPHA = albedo.a * albedo_tex.a;
}
