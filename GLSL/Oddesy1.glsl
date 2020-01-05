// from Mr Hoskins ST;
// EDIT By JADIS










#ifdef GL_ES
precision lowp float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float 	offset=2.0;
void main()
{
	
	 vec2 uv = gl_FragCoord.xy / resolution.xy *2.0-1.0;
	 
	
    float s = mouse.x, v = 0.0;
	
	
        offset = time*time/500.;
 
	
	float speed2 = (cos(offset)+1.0)*2.0;
	float speed = speed2+.1;
	 
	offset += cos(offset)*3.96;
	offset *= 2.0;
 	vec3 col = vec3(0);
    vec3 init = vec3(sin(offset * .005)*.1, .35 + cos(offset * .005)*.5, offset * 0.1);
	for (int r = 0; r < 80; r++) 
	{
		vec3 p = init + s * vec3(uv, 0.05);
		p.z = fract(p.z);
        // Thanks to Kali's little chaotic loop...
		for (int i=0; i < 8; i++)	p = abs(p * 2.04) / dot(p, p) - .9;
		v += pow(dot(p, p), .7) * .1;
		col +=  vec3(v * 0.5+.4, 5.-s*1., .1 + v * 3.) * v * 0.00005;
		s += .025;
	}
	gl_FragColor = vec4(clamp(col, 0.0, 5.0), 2.0);
}