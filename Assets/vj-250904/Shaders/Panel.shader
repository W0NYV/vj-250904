Shader "CustomRenderTexture/Panel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
        
        [Toggle(_G001)]g001("G001", Float) = 0
        [Toggle(_G002)]g002("G002", Float) = 0
     }

     SubShader
     {
        Blend One Zero

        Pass
        {
            Name "Panel"

            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #include "_hlsl/Common.hlsl"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            #pragma multi_compile _ _G001
            #pragma multi_compile _ _G002

            float4      _Color;
            sampler2D   _MainTex;
            float _GlobalTime;

            float g001(float2 uv)
            {
                uv.y += _GlobalTime/16.0;
                uv.x += hash(float3(floor(uv.x*3.0), 312.23, 2312)).x * 100.0; 

                Subdiv subdiv = subdivision(uv, _GlobalTime);
                
                float f = 0.0;
                
                float rnd = hash(float3(floor(_GlobalTime), subdiv.id)).r;

                float2 p = subdiv.uv;

                p -= 0.5;
                p = mul(p, rot(acos(-1.0)/2.0*floor(rnd*2.0)));
                p += 0.5;

                float c0 = step(length(p), 2.0/3.0) + step(length(p-float2(1.0,1.0)), 2.0/3.0);
                float c1 = step(length(p), 1.0/3.0) + step(length(p-float2(1.0,1.0)), 1.0/3.0);
                float c2 = step(length(p), 1.0/6.0) + step(length(p-float2(1.0,1.0)), 1.0/6.0);
                float c2i = step(length(p-float2(1.0, 0.0)), 1.0/6.0) + step(length(p-float2(0.0,1.0)), 1.0/6.0);
                float c3 = step(length(p), 1.0/12.0) + step(length(p-float2(1.0,1.0)), 1.0/12.0);
                float c3i = step(length(p-float2(1.0, 0.0)), 1.0/12.0) + step(length(p-float2(0.0,1.0)), 1.0/12.0);
                float c3r = step(length(p-float2(0.5, 0.0)), 1.0/12.0) + step(length(p-float2(0.5,1.0)), 1.0/12.0);
                float c3ri = step(length(p-float2(0.0, 0.5)), 1.0/12.0) + step(length(p-float2(1.0,0.5)), 1.0/12.0);

                if (subdiv.count == 1) {
                    f = (c0 - c1) + (c2 + c2i) - (c3 + c3i + c3r + c3ri);
                } else if (subdiv.count == 2) {
                    f = 1.0 - (c2 + c2i + c0 - c1);
                } else if (subdiv.count == 3 || subdiv.count == 4) {
                    f = c0 - c1;
                }

                return f;
            }

            float g002(float2 uv)
            {
                float2 fp = float2(fract(uv.x * 3.0), uv.y) - 0.5;
                float f = 0.0;

                for (float i = -0.2; i <= 0.2; i += 0.2)
                {
                    float2 p2 = fp;
                    p2.x += cyclic(float3(p2.y, floor(uv.x*3.0)-0.5 + i, floor(_GlobalTime*4.0)), 1.5).r * 0.2;
                    f += step(length(p2.x - i), 0.01);
                }

                return min(f, 1.0);
            }

            float4 frag(v2f_customrendertexture IN) : SV_Target
            {
                float2 uv = IN.localTexcoord.xy;

                float d = 0;
#if _G001
                d = g001(uv);
#elif _G002
                d = g002(uv);
#endif
                
                return float4(d.xxx, 1.0);
            }
            ENDCG
        }
    }
}
