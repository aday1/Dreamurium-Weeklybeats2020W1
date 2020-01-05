// original https://www.shadertoy.com/view/tdGXWm

precision highp float;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

#define PI 3.14159

float VDrop2(vec2 uv)
{
    uv.x *= sin(1.+uv.y*.525)*0.4;			// ADJUST PERSP
    float t =  time*0.1;
    uv.x = uv.x*128.0;					// H-Count
    float dx = fract(uv.x);
    uv.x = floor(uv.x);
    uv.y *= 0.15;					// stretch
    float o=sin(uv.x*215.4);				// offset
    float s=cos(uv.x*33.1)*.3 +.7;			// speed
    float trail = mix(145.0,15.0,s);			// trail length
    float yv = 1.0/(fract(uv.y + t*s + o) * trail);
    yv = smoothstep(mouse.x,0.1,yv*yv);
    yv = sin(yv*PI)*(s*2.0);
    float d = sin(dx*PI);
    return yv*(d*d);
}


void main(void)
{ 
 vec2 uv = (gl_FragCoord.xy * 2.0 - resolution) / min(resolution.x, resolution.y);
 vec3 col = vec3(15.1,5.0,0.5)*VDrop2(uv);
 gl_FragColor=vec4(col,1.);
}