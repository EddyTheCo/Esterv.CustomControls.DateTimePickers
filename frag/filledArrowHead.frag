#version 440
#define PI     3.1415926535898
#define W    0.05

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 pixelStep;
    vec4 fcolor;
    float iTime;
};
layout(binding = 1) uniform sampler2D src;

float sdEquilateralTriangle(  in vec2 p, in float r )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - r;
    p.y = p.y + r/k;
    if( p.x+k*p.y>0.0 ) p=vec2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0*r, 0.0 );
    return -length(p)*sign(p.y);
}
void main( void)
{
    vec2 uv = 2.0*qt_TexCoord0-1.0;

    vec2 p;
    float phi=PI*iTime;

    p.x=uv.x*cos(phi)+uv.y*sin(phi);
    p.y=-uv.x*sin(phi)+uv.y*cos(phi);

    float d1=1.0-smoothstep(0.0,0.05,sdEquilateralTriangle(p,0.8));

    vec4 bcolor=texture(src, qt_TexCoord0).rgba;
    vec4 color=mix(bcolor,fcolor , d1);

    fragColor = color;

}
