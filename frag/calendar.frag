#version 440

#define PI     3.14159265
#define BLUR   0.01
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
	mat4 qt_Matrix;
	float qt_Opacity;
	vec2 pixelStep;
	float iTime;
	vec4 fcolor;
};
layout(binding = 1) uniform sampler2D src;

float sdBox( in vec2 p, in vec2 b )
{
	vec2 d = abs(p)-b;
	return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}
float sdCircle( vec2 p, float r )
{
	return length(p) - r;
}
void main( void)
{
        vec2 uv=vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);


        float f=smoothstep(0.0,BLUR,sdBox(uv-vec2(0.5,0.4),vec2(0.4,0.3)));
        f+=1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.2,0.55),vec2(0.05,0.05)));
        f+=1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.5,0.55),vec2(0.05,0.05)));
        f+=(1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.8,0.55),vec2(0.05,0.05))))*cos(PI*iTime);
        f+=(1.0-smoothstep(0.0,BLUR,sdCircle(uv-vec2(0.8,0.55),0.04)))*(1.0-cos(PI*iTime));

        f-=1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.1,1.0),vec2(0.1,0.1)));
        f-=1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.5,1.0),vec2(0.2,0.1)));


        f-=1.0-smoothstep(0.0,BLUR,sdBox(uv-vec2(0.9,1.0),vec2(0.1,0.1)));

	vec4 bcolor=texture(src, uv).rgba;
	fragColor=mix(bcolor, fcolor, f);

}

