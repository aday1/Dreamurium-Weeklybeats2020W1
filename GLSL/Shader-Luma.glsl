// global remix - Del 30/10/2019
#ifdef GL_ES
precision highp float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec4 inputColour;

float snow(vec2 uv,float scale)
{
	float _t = time*.95;
	 uv.x+=_t/scale;
	uv*=scale;vec2 s=floor(uv),f=fract(uv),p;float k=1.,d;
	p=.1+.25*sin(11.*fract(sin((s+p+scale)*mat2(7,3,6,5))*2.))-f;d=length(p);k=min(d,k);
	k=smoothstep(0.,k,sin(f.x+f.y)*0.002);
    	return k;
}

void main(void){
	vec2 uv=(gl_FragCoord.xy*2.-resolution.xy)/min(resolution.x,resolution.y);
	float dd = 1.0-length(uv*inputColour.x*2.1);  //size
	//uv.x += sin(time*0.08);
	//uv.y += sin(uv.x*1.4)*0.2;
	uv.x *= mouse.y*1.09;
	float c=smoothstep(0.1,0.0,clamp(uv.x*.01+.99,0.,.99));
	c+=snow(uv,3.)*.8;
	c+=snow(uv,5.)*.7;
	c+=snow(uv,7.)*.6;

	c+=snow(uv,9.)*.3;

	c+=snow(uv,11.)*.4;

	c+=snow(uv,13.)*.3;



	c*=2.*(-0.99)/dd;
	vec3 finalColor=(vec3(0.95,2.4,mouse.x*9.0))*c*40.0;
	gl_FragColor = vec4(finalColor,100);
}
