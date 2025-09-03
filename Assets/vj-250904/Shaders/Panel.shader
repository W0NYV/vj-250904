Shader "CustomRenderTexture/Panel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("InputTex", 2D) = "white" {}
        
        [Toggle(_G001)]g001("G001", Float) = 0
        [Toggle(_G002)]g002("G002", Float) = 0
        [Toggle(_G003)]g003("G003", Float) = 0
        [Toggle(_G004)]g004("G004", Float) = 0
        [Toggle(_G005)]g005("G005", Float) = 0
        [Toggle(_G006)]g006("G006", Float) = 0
        [Toggle(_G007)]g007("G007", Float) = 0
        [Toggle(_G008)]g008("G008", Float) = 0
        [Toggle(_G009)]g009("G009", Float) = 0
        [Toggle(_G010)]g010("G010", Float) = 0
        [Toggle(_G011)]g011("G011", Float) = 0
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
            #pragma multi_compile _ _G003
            #pragma multi_compile _ _G004
            #pragma multi_compile _ _G005
            #pragma multi_compile _ _G006
            #pragma multi_compile _ _G007
            #pragma multi_compile _ _G008
            #pragma multi_compile _ _G009
            #pragma multi_compile _ _G010
            #pragma multi_compile _ _G011
            #pragma multi_compile _ _G012

            float4      _Color;
            sampler2D   _MainTex;
            float _GlobalTime;
            float3 _HSVColor;
            float _GradApplyValue;

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
            
            float g003(float2 uv)
            {
                uv.y += _GlobalTime/8.0;

                float2 ip = float2(floor(uv.x*9.0), floor(uv.y*90.0));

                float r = hash(float3(ip, floor(_GlobalTime))).r;
                float rNext = hash(float3(ip, floor(_GlobalTime)+1.0)).r;
                r = lerp(r, rNext, easeOutElastic(fract(_GlobalTime)));

                return pow(r, 6.0);
            }

            float g004(float2 p)
            {
                float f = 1.0;
                float2 fp = fract(p * 4.0);
                float2 ip = floor(p * 4.0);
                
                float t = (floor(_GlobalTime/2.0)+easeOutElastic(fract(_GlobalTime/2.0)))*2.0 + _GlobalTime * 2.0;
                
                for (float x = -1.0; x <= 1.0; x += 1.0)
                {
                    for (float y = -1.0; y <= 1.0; y += 1.0)
                    {
                        float2 n = float2(x, y);
                        float2 pt = cyclic(float3(n + ip, t), 10.0).xy * 0.5 + 0.5;
                        float2 diff = n + pt - fp;
                        f = min(f, length(diff));
                    }
                }
    
                return clamp(pow(sin(f * 30.0 + _GlobalTime), 3.0), 0.0, 1.0);
            }

            float g005(float2 uv)
            {
                float o = floor(uv.x * 3.0)/3.0 * acos(-1.0) * 2.0;
                return clamp(pow(sin(-uv.y - _GlobalTime / 2.0 + o), 8.0), 0.0, 1.0);
            }

            float g006(float2 uv)
            {
                float aspect = 21.0/27.0;

                float3 rnd = hash(float3(floor(uv.x*42.0), 323.23, 12.12));
                float oSpeed = rnd.x < 0.5 ? clamp(rnd.y, 0.1, 0.5) : -clamp(rnd.y, 0.1, 0.5);
                uv.y += oSpeed * (floor(_GlobalTime) + easeOutExpo(fract(_GlobalTime))) + oSpeed * _GlobalTime * 0.25;

                float2 ip = float2(floor(uv.x*42.0), floor(uv.y*6.0*aspect));

                float f = step(hash(float3(ip, 31.21)).r, 0.2);

                return f;
            }

            float g007(float2 uv) {

                float aspect = 21.0/27.0;

                float3 s = hash(float3(floor(uv.x*3.0), 342.23, 65.45));
                uv.y += _GlobalTime / 4.0 * (0.8 + s.y * 0.2) + s.x;

                float2 ip = floor(uv*float2(3.0, 3.0 * aspect)) - 0.5;
                float2 fp = fract(uv*float2(3.0, 3.0 * aspect)) - 0.5;
                float3 rnd = hash(float3(ip, 431.21));
                float3 rndBeat = hash(float3(ip, floor(_GlobalTime)));

                float dest = 0.0;

                if (rnd.x < 1.0/3.0) {
                    float2 p2 = fp;
                    p2 = mul(p2, rot(acos(-1.0)/4.0));
                    p2.x += _GlobalTime * 0.1;
                    dest = step(sin(p2.x*40.0), 0.0) * step(sdBox(fp, 0.35), 0.0);
                } else if (rnd.x < 2.0/3.0) {
                    float2 p2 = fp;
                    float time = easeOutExpo(fract(_GlobalTime))*0.375;
                    p2 = mul(p2, rot(acos(-1.0)/-4.0));
                    float f = step(sdChamferBox(p2, 0.4), 0.0);
                    float ff = step(sdChamferBox(p2, time), 0.0);
                    dest = f - ff;
                } else {
                    float2 p2 = fp;
                    p2 = mul(p2, rot(acos(-1.0)/-4.0));
                    p2 = mul(p2, rot(acos(-1.0)/-4.0 * 2.0 * floor(rndBeat.x*4.0)));
                    float2 p3 = p2;
                    p2.y += 0.4;
                    p2.x = abs(p2.x);
                    p2 = mul(p2, rot(acos(-1.0)/-4.0) * skew(acos(-1.0)/-4.0));
                    p2.x -= 0.15;
                    float f = step(sdBox(p2, float2(0.15, 0.1)), 0.0);
                    f += step(sdBox(p3, float2(0.125, 0.375)), 0.0);
                    dest = min(1.0, f);
                }

                return dest;
            }

            float g008(float2 uv)
            {
                float2 fp = float2(fract(uv.x*3.0), uv.y) - 0.5;
                float id = floor(uv.x*3.0);
                fp *= 0.5;
                
                float f = 0.0;
                
                for (float i = 0.0; i < 11.0; i += 1.0) {
                    float3 rnd = hash(float3(i, id, floor(_GlobalTime)));
                    float3 rndNext = hash(float3(i, id, floor(_GlobalTime) + 1.0));
                    
                    float3 rndL = lerp(rnd, rndNext, easeOutExpo(fract(_GlobalTime)));
                    
                    float2 pos = randomNormal(rndL.xy) * float2(0.05, 0.15);
                    float size = 0.025 + abs(randomNormal(rndL.yz)).x * 0.05;

                    float d = step(length(fp - pos), size);
                    
                    f = abs(f - d);
                }

                return f;
            }

            float g009(float2 uv) {
                
                float2 fp = float2(fract(uv.x*3.0), fract(uv.y*3.7));

                float offset = hash(float3(floor(uv.x*3.0), floor(uv.y*3.7), 341.23)).r * 2.0;

                return eye(fp, _GlobalTime, offset);
            }

            float g010(float2 p) {
                float dest = 0.0;

                p = mul(p, rot(_GlobalTime/16.0));

                for (int i = 0; i < 64; i++) {
                    float3 rnd = hash(float3(i, floor(_GlobalTime*2.0), 423.3));

                    float2 p2 = p;

                    p2 = mul(p2, rot(acos(-1.0) * rnd.z));
                    p2.x += (rnd.x * 2.0 - 1.0) * 2.0;
                    p2.y += rnd.y * 2.0 - 1.0;

                    float d = sdBox(p2, float2(0.01, 0.7));

                    dest += step(d, 0.0);
                }

                return min(dest, 1.0);
            }

            float g011(float2 p)
            {
                float t = floor(_GlobalTime) + easeOutElastic(fract(_GlobalTime));

                float cx = cyclic(float3(p * 0.5, t * 0.45), 2.0).r;
                float cy = cyclic(float3(p.y, t * 0.45, p.x * 2.0), 2.0).r;

                float2 p2 = float2(cx, cy);
                p2 = mul(p2, rot(-_GlobalTime * 0.2));

                float c = cyclic(float3(p2.y * 10.0, t * 0.3, p2.x * 10.0), 10.0).x;

                return pow(sin(c * 2.0), 3.0);
            }

            float g012(float2 uv)
            {
                float2 fp = float2(fract(uv.x*16.0), uv.y) - 0.5;
                float t = _GlobalTime + (floor(uv.x*16.0)-0.5)/(7.0/32.0);
                float d = step(sdBox(fp, float2(easeInElastic(fract(-t/8.0)), 1.0)), 0.0);
                d = mod(floor(-t), 16.0) > 7.0 ? d : 1.0 - d;
                return d;
            }
            
            float4 frag(v2f_customrendertexture IN) : SV_Target
            {
                float2 uv = IN.localTexcoord.xy;

                float d = 0;
#if _G001
                d = g001(uv);
#elif _G002
                d = g002(uv);
#elif _G003
                d = g003(uv);
#elif _G004
                d = g004(uv);
#elif _G005
                d = g005(uv);
#elif _G006
                d = g006(uv);
#elif _G007
                d = g007(uv);
#elif _G008
                d = g008(uv);
#elif _G009
                d = g009(uv);
#elif _G010
                d = g010(uv);
#elif _G011
                d = g011(uv);
#elif _G012
                d = g012(uv);
#endif
                
                float3 nCol = inferno_quintic(clamp(1.0 - abs(cyclic(float3(uv * 4.0, floor(_GlobalTime*2.0)), 2.0).r), 0.075, 1.0));
                float3 col = lerp(hsv2rgb(saturate(_HSVColor)), nCol, _GradApplyValue) * d;
                
                return float4(col, 1.0);
            }
            ENDCG
        }
    }
}
