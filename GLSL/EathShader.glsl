// Créé par andremichelle le 2019-11-15
// From Shadertoy ; Gigatron for glslsandbox : !

#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI_INV 0.318309
#define PI_TWO_INV 0.15915
#define clip(x) clamp(x, 0., 1.)

float Hash(in vec2 p, in float scale) {
    return fract(sin(dot(mod(p, scale), vec2(27.16898, 38.90563))) * 5151.5473453);
}

vec3 check(vec2 uv, float s) {
    return vec3(.12+0.06*mod(floor(s*uv.x)+floor(s*uv.y),2.0));
}

float Noise(in vec2 p, in float scale ) {
    vec2 f;
    p *= scale;
    f = fract(p);
    p = floor(p);
    f = f*f*(3.0-2.0*f);
    return mix(mix(Hash(p, scale),
            Hash(p + vec2(1.0, 0.0), scale), f.x),
            mix(Hash(p + vec2(0.0, 1.0), scale),
            Hash(p + vec2(1.0, 1.0), scale), f.x), f.y);
}

float fbm(in vec2 p, float scale) {
    float f = 0.0;
    p = mod(p, scale);
    float amp   = .6;
    for (int i = 0; i < 5; i++)
    {
        f += Noise(p, scale) * amp;
        amp *= .7;
        scale *= 2.;
    }
    return min(f, mouse.x);
}

vec4 over( in vec4 a, in vec4 b ) {
    return mix(a, b, 1.-a.w);
}

void main() {
    vec2 uv = (gl_FragCoord.xy-resolution.xy*0.5)/resolution.y*2.;

    float l = length(uv);
    float a = atan(uv.y, uv.x);
    float t = time;
    float p = sin(t*.25);
    vec4 c = vec4(0.1);
    
    c = over(vec4(vec3(1., .8, .6), pow(distance(uv, vec2(.98, .3)), -.5)*.01), c);
    c = over(vec4(vec3(1., .8, .6), pow(distance(uv, vec2(-.98, -.8)), -.5)*.01), c);
    
    vec2 ws;
    ws = normalize(uv)*((2.+p*.1)*asin(length(uv)*2.) * PI_INV);
    ws.x += t*.04;
    float r;
    vec3 sun;
    vec3 
        c0 = vec3(.2, .0, .0), 
        c1 = vec3(1., .1, .0),
        c2 = vec3(1., time, .0),
        c3 = vec3(1., time, 1.);
    r = smoothstep(.45+p*.1, 1., fbm(ws, 20.));
    sun = mix(c0, mix(c1, mix(c2, c3, clip(r*1.-2.)), clip(r*4.-1.)), clip(r*3.));
    c = over(vec4(sun, smoothstep(.05, .0, l-.493)), c);

    ws = vec2(a*PI_TWO_INV+l*sin(t*.1)*.004, l*.01);
    ws.y -= t*.008;
    r = smoothstep(.6, .0, fbm(ws, 20.) * smoothstep(.2, .9, l)*1.25);
    sun = mix(c0, mix(c1, mix(c2, c3, clip(r*3.-2.)), clip(r*3.-1.)), clip(r*3.));
    c = over(vec4(sun, pow(smoothstep(.1, .6, l), 4.) * r), c);
    
    r = smoothstep(.9, .0, fbm(ws+.25, 5.) * smoothstep(.4, .6, l*1.1));
    sun = mix(c0, mix(c1, mix(c2, c3, clip(r*3.-2.)), clip(r*3.-1.)), clip(r*3.));
    c = over(vec4(sun, pow(smoothstep(.0, .8, l*1.2), .2) * r * .1), c);
    
    gl_FragColor = vec4(c);
    gl_FragColor.a =1.0;
}