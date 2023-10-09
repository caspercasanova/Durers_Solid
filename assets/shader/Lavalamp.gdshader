shader_type spatial;
render_mode unshaded, depth_test_disabled;
uniform int MAX_STEPS = 100;
uniform float MAX_DISTANCE = 100.0;
uniform float SURF_DISTANCE =  0.01;
uniform float TIMESCALE = 0.1;
uniform float SHAPE_SIZE = 2.0;
// https://www.youtube.com/watch?v=jH0MD8obOCQ
// booleans
float union(float a, float b){
	return min(a, b);
}

float subtraction(float a, float b){
	return max(-a, b);
}

float interesection(float a, float b){
	return max(a, b);
}


float sdSphere(vec3 p, vec3 sp, float r){
	return length(sp - p) - r;
}

float GetDist(vec3 p){
	float t = TIME * TIMESCALE;
	vec3 shape1_pos = (vec3(sin(t * 0.337), abs(sin(t * 0.428)), sin(t * -0.989)));
	vec3 shape2_pos = (vec3(sin(t * -0.214), abs(sin(t * 0.725)), sin(t * -0.989)));
	vec3 shape3_pos = (vec3(sin(t * -0.671), abs(sin(t * 0.272)), sin(t * 0.773)));
	
	vec3 move_scale = vec3(0.2, 3.0, 0.2);
	
	float sp1 = sdSphere(p, shape1_pos * move_scale, SHAPE_SIZE * 0.5);
	float sp2 = sdSphere(p, shape2_pos * move_scale, SHAPE_SIZE * 0.75);
	float sp3 = sdSphere(p, shape3_pos * move_scale, SHAPE_SIZE);
	float sp4 = sdSphere(p, vec3(0.0), 0.8);
	
	return 1.0; // placeholder
}

vec3 GetNormal(vec3 p){
	float d = GetDist(p);
	vec2 e = vec2(0.01, 0.0);
	vec3 n = vec3(
		GetDist(p-e.xyy),
		GetDist(p-e.yxy),
		GetDist(p-e.yyx)
	);
	return normalize(n);
}


float RayMarch(vec3 ro, vec3 rd){
	float d = 0.0;
	for(int i = 0; i < MAX_STEPS; i++){
		vec3 p = ro + rd * d; // step along ray 
		float dS = GetDist(p); 
		d += dS;
		if(d > MAX_DISTANCE || dS < SURF_DISTANCE) break;
	}
	
	return d;
}

void fragment() {
	vec3 ws_pixel_position = ((INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz);
	vec3 ro = CAMERA_POSITION_WORLD;
	vec3 rd = normalize(ws_pixel_position - ro);
	
	float d = RayMarch(ro, rd);
	ALPHA = step(d, MAX_DISTANCE);
	// Place fragment code here.
	vec3 n = GetNormal(ro + rd * d);
	ALBEDO = n;
	
}
