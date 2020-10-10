shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx; //speculat_pong is nice option
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D texture_albedo2 : hint_albedo;
uniform sampler2D noise_mix : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform sampler2D texture_normal;
uniform sampler2D texture_height;
uniform float normal_scale : hint_range(-16,16);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
uniform float texelMaxHeight;
uniform float eps = 0.001;
uniform float height_mdfy;

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec3 getNormal(vec2 uv) {
  
  float u = texture(texture_height, uv + vec2(0.0, -eps)).r * texelMaxHeight;
  float r = texture(texture_height, uv + vec2(eps, 0.0)).r * texelMaxHeight;
  float l = texture(texture_height, uv + vec2(-eps, 0.0)).r * texelMaxHeight;
  float d = texture(texture_height, uv + vec2(0.0, eps)).r * texelMaxHeight;
  
  vec3 n;
  n.z = u - d;
  n.x = l - r;
  n.y = 2.0;
  return normalize(n);
}


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
//	UV.x += TIME / 10.0;
//	UV.y += TIME / 15.0;
	VERTEX.y += texture(texture_height,UV).r * height_mdfy;
	NORMAL = getNormal(UV);
}




void fragment() {
	vec2 base_uv = UV * 10.0;
	vec2 noise_uv = UV;
//	vec4 flow_tex = texture(texture_normal,base_uv);
//	base_uv += flow_tex.rg * (sin(1.0) / 2.0 + 1.0);

//	float a = rand(ceil(UV * 10.0));
//	base_uv *= mat2(vec2(cos(a), -sin(a)), vec2(sin(a), cos(a)));
	vec4 noise_tex = texture(noise_mix, noise_uv);
	vec4 albedo_tex = texture(texture_albedo,base_uv / 1.2);
	vec4 albedo_tex2 = texture(texture_albedo2,base_uv);
//	albedo_tex.gb -= noise_tex.gb / 3.0;
	vec4 mix_tex = albedo_tex * noise_tex.r / 1.0 + albedo_tex2 * (1.0 - noise_tex.r) / 1.0;
	
	ALBEDO = albedo.rgb * mix_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
//	NORMALMAP = texture(texture_normal,base_uv).rgb;
//	NORMALMAP_DEPTH = normal_scale;
}







