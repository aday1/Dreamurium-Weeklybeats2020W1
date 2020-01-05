#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// need some dust particles.

vec3 galaxy(vec2 uv,float speed){

	float t = speed * .1 + ((.25 + .05 * sin(speed * .1))/(length(uv.xy+vec2(10.1,1.1)) + .07)) * 2.2;
	float si = sin(t);
	float co = cos(t);
	mat2 ma = mat2(co, si, -si, co);

	float v1, v2, v3;
	v1 = v2 = v3 = 0.0;
	
	float s = 0.0;
	for (int i = 0; i < 50; i++){
		vec3 p = s * vec3(uv, 0.0);
		p.xy *= ma;
		p += vec3(.8, .2, s - 1.0 - sin(speed * 1.13) * .1);
		for (int i = 0; i < 8; i++)	p = abs(p) / dot(p,p) - 0.659;
		v1 += dot(p,p) * .0015 * (1.8 + sin(length(uv.xy * 13.0) + .5  - speed * .2));
		v2 += dot(p,p) * .0013 * (1.5 + sin(length(uv.xy * 14.5) + 1.2 - speed * .3));
		v3 += length(p.xy*10.) * .0003;
		s  += .035;
	}
	
	float len = length(uv);
	v1 *= smoothstep(.7, .0, len);
	v2 *= smoothstep(.5, mouse.y*5.0, len);
	v3 *= smoothstep(.9, .0, len);
	
	
	vec3 col = vec3( v3 * (1.5 + sin(mouse.x * .2) * .4),
					(v1 + v3) * .3,
					 v2) + smoothstep(0.2, .0, len) * .85 + smoothstep(.0, .6, v3) * .3;	
					
	return min(pow(abs(col), vec3(1.2)), 1.0);				
}

vec3 postprocess(vec3 col){
col = 0.001+pow(col, vec3(1.2))*1.5;
	col = clamp(1.06*col-0.03, 0., 1.);   
    	col *= mod(gl_FragCoord.y, 4.0)<2.0 ? mouse.x: 1.0;

	return col;
}


void main( void ) {
	
	 
	
	vec2 uv = 7.*(( gl_FragCoord.xy / resolution.xy ) - 0.5)  ;
	
	uv *=vec2(0.4,0.4);
	 
	float speed = -time*0.9;
	
	vec3 color = galaxy(uv,speed);
	 
	gl_FragColor = vec4(color,1.0);

}