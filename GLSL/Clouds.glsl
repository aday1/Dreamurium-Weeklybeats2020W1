#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 ndc(vec2 fragCoord, vec2 res) {
	return normalize(vec3((fragCoord - res / 2.0) / min(res.x, res.y), 0.05));
}

vec3 render(vec2 fragCoord, vec2 res, float seconds) {
	vec3 spatial = ndc(fragCoord, res) * 15.0 + vec3(0.0, 0.0, seconds);
	vec3 cell = floor(spatial);
	vec3 relativeToCell = fract(spatial);
	vec3 ret = max(vec3(0.0), vec3(10.0 * (0.1 - distance(relativeToCell, fract(cross(cell, vec3(2.154, -6.21, 0.42))) * 0.5 + 0.25))));
	return pow(ret + vec3(0.0025, 0.01, 0.025) * vec3(max(0.0, sin(dot(spatial, vec3(0.04, -0.03, 0.021))))), vec3(1.0 / 2.2));
}

void main( void )
{
	gl_FragColor = vec4( render(gl_FragCoord.xy, resolution, time), 1.0 );

}