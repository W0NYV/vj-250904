#ifndef COMMON_INCLUDED
#define COMMON_INCLUDED

uint3 Pcg3d(float3 s) {
    uint3 v = asuint(s);
    
    v = v * 1664525u + 1013904223u;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    v ^= v >> 16u;

    v.x += v.y*v.z;
    v.y += v.z*v.x;
    v.z += v.x*v.y;

    return v;
}

float3 hash(float3 v)
{
    float floatMax = 1.0/float(0xffffffffu);
    return Pcg3d(v) * floatMax;
}

float3x3 orthbas( float3 z )
{
    z = normalize( z );
    float3 up = abs( z.y ) < 0.999 ? float3( 0, 1, 0 ) : float3( 0, 0, 1 );
    float3 x = normalize( cross( up, z ) );
    return float3x3( x, cross( z, x ), z );
}

float3 cyclic( float3 p, float pump )
{
    float3x3 b = orthbas( float3( -3.0, 2.0, -1.0 ) );
    float4 sum = 0.0;

    for( int i = 0; i < 5; i ++ ) {
        p = mul(p, b);
        p += sin( p.yzx );
        sum += float4( cross( cos( p ), sin( p.zxy ) ), 1.0 );
        p *= 2.0;
        sum *= pump;
    }
  
    return sum.xyz / sum.w;
}

float2x2 rot(float r)
{
    return float2x2(cos(r), -sin(r), sin(r), cos(r));
}

// https://scrapbox.io/sayachang/GLSL%E3%82%92HLSL%E3%81%AB%E6%9B%B8%E3%81%8D%E6%8F%9B%E3%81%88%E3%82%8B
float mod(float x, float y)
{
    return x - y * floor(x / y);
}
float2 mod(float2 x, float2 y)
{
    return x - y * floor(x / y);
}
float3 mod(float3 x, float3 y)
{
    return x - y * floor(x / y);
}
float4 mod(float4 x, float4 y)
{
    return x - y * floor(x / y);
}

float fract(float x)
{
    return x - floor(x);
}

float2 fract(float2 x)
{
    return x - floor(x);
}

float3 fract(float3 x)
{
    return x - floor(x);
}

float4 fract(float4 x)
{
    return x - floor(x);
}

struct Subdiv
{
    float2 id;
    float2 uv;
    float2 size;
    int count;
};

Subdiv subdivision(float2 p, float time)
{
    float2 size = 0.5;
    Subdiv dest;
    dest.id = 0;
    dest.uv = 0;
    dest.size = 0;
    dest.count = 0;

    for (int i = 0; i < 4; i++) {
        dest.id = (floor(p/size)) * size;
        dest.uv = fract(p/size);

        float3 rnd = hash(float3(dest.id, floor(time)));

        if (i != 0 && rnd.x < 0.5)
        {
            break;
        }
        else
        {
            size *= 0.5;
            dest.count++;
        }
    }

    dest.size = size;
    return dest;
}

float easeInElastic(float x)
{
    float c4 = acos(-1.0) * 2.0 / 3.0;
    return x == 0.0 
    ? 0.0 : x == 1.0 
    ? 1.0 : -pow(2, 10.0 * x - 10.0) * sin((x * 10.0 - 10.75) * c4);
}

float easeOutElastic(float x) {
    float c4 = (2.0 * acos(-1.0)) / 3.0;
    return x == 0.0 ? 0.0 : x == 1.0 ? 1.0 : pow(2.0, -10.0 * x) * sin((x * 10.0 - 0.75) * c4) + 1.0;
}

float getIntensity(float3 col)
{
    return dot(col, float3(0.299, 0.587, 0.114));
}

float3 hsv2rgb(float3 c)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// https://www.shadertoy.com/view/XtGGzG
float3 inferno_quintic( float x )
{
    x = saturate( x );
    float4 x1 = float4( 1.0, x, x * x, x * x * x ); // 1 x x2 x3
    float4 x2 = x1 * x1.w * x; // x4 x5 x6 x7
    return saturate( float3(
        dot( x1.xyzw, float4( -0.027780558, +1.228188385, +0.278906882, +3.892783760 ) ) + dot( x2.xy, float2( -8.490712758, +4.069046086 ) ),
        dot( x1.xyzw, float4( +0.014065206, +0.015360518, +1.605395918, -4.821108251 ) ) + dot( x2.xy, float2( +8.389314011, -4.193858954 ) ),
        dot( x1.xyzw, float4( -0.019628385, +3.122510347, -5.893222355, +2.798380308 ) ) + dot( x2.xy, float2( -3.608884658, +4.324996022 ) ) ) );
}

float3 magma_quintic( float x )
{
    x = saturate( x );
    float4 x1 = float4( 1.0, x, x * x, x * x * x ); // 1 x x2 x3
    float4 x2 = x1 * x1.w * x; // x4 x5 x6 x7
    return saturate( float3(
        dot( x1.xyzw, float4( -0.023226960, +1.087154378, -0.109964741, +6.333665763 ) ) + dot( x2.xy, float2( -11.640596589, +5.337625354 ) ),
        dot( x1.xyzw, float4( +0.010680993, +0.176613780, +1.638227448, -6.743522237 ) ) + dot( x2.xy, float2( +11.426396979, -5.523236379 ) ),
        dot( x1.xyzw, float4( -0.008260782, +2.244286052, +3.005587601, -24.279769818 ) ) + dot( x2.xy, float2( +32.484310068, -12.688259703 ) ) ) );
}
#endif