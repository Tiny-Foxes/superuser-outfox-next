// V-Drop - Del 19/11/2019 - (Tunnel mix - Enjoy)
// vertical version: https://www.shadertoy.com/view/tdGXWm
#define PI 3.14159

varying vec2 textureCoord;
uniform vec2 textureSize;
uniform float time;

vec3 iMouse = vec3(0.0);

float vDrop(vec2 uv,float t)
{
    uv.x = uv.x*128.0;						// H-Count
    float dx = fract(uv.x);
    uv.x = floor(uv.x);
    uv.y *= 0.05;							// stretch
    float o=sin(uv.x*215.4);				// offset
    float s=cos(uv.x*33.1)*.3 +.7;			// speed
    float trail = mix(95.0,35.0,s);			// trail length
    float yv = fract(uv.y + t*s + o) * trail;
    yv = 1.0/yv;
    yv = smoothstep(0.0,1.0,yv*yv);
    yv = sin(yv*PI)*(s*5.0);
    float d2 = sin(dx*PI);
    return yv*(d2*d2);
}

void main()
{
    vec2 p = (textureCoord.xy - 0.5 * textureSize.xy) / textureSize.y;
    float d = length(p)+0.1;
	p = vec2(atan(p.x, p.y) / PI, 2.5 / d);
    if (iMouse.z>0.5)
    	p.y *= 0.5;
    float t =  time*0.4;
    vec3 col = vec3(1.55,0.65,.225) * vDrop(p,t);	// red
    col += vec3(0.55,0.75,1.225) * vDrop(p,t+0.33);	// blue
    col += vec3(0.45,1.15,0.425) * vDrop(p,t+0.66);	// green
	gl_FragColor = vec4(col*(d*d), col);
}
