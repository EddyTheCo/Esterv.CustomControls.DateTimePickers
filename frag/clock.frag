#version 440
#define PI     3.14159265

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

float sdCircle( vec2 p, float r )
{
	return length(p) - r;
}

float sdSegment( in vec2 p, in vec2 a, in vec2 b )
{
	vec2 pa = p-a, ba = b-a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length( pa - ba*h );
}

void main( void)
{
        vec2 uv=vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);


	float f=-smoothstep(0.0,0.001,sdCircle(uv-0.5,0.5));
        f+=smoothstep(0.0,0.001,sdCircle(uv-0.5,0.42));

        f+= 1.0-smoothstep(0.0,0.001,sdSegment(uv,vec2(0.5),vec2(0.5,0.75))-0.035);
	f+= 1.0-smoothstep(0.0,0.001,sdSegment(uv,vec2(0.5),
    vec2(0.5+0.35*cos(iTime*PI),0.5-0.35*sin(iTime*PI)))-0.035);

	vec4 bcolor=texture(src, uv).rgba;
        fragColor=mix(bcolor, fcolor, clamp(0.0,1.0,f));

}

