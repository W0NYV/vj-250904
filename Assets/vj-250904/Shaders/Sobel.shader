Shader "Hidden/Sobel"
{
    Properties
    {
        _MainTex ("tex2D", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "_hlsl/Common.hlsl"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                
                float3 mr = tex2D(_MainTex, uv + float2(_MainTex_TexelSize.x, 0.0)).rgb;
                float3 ml = tex2D(_MainTex, uv + float2(-_MainTex_TexelSize.x, 0.0)).rgb;

                float3 tc = tex2D(_MainTex, uv + float2(0.0, _MainTex_TexelSize.y)).rgb;
                float3 tr = tex2D(_MainTex, uv + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y)).rgb;
                float3 tl = tex2D(_MainTex, uv + float2(-_MainTex_TexelSize.x, _MainTex_TexelSize.y)).rgb;

                float3 bc = tex2D(_MainTex, uv + float2(_MainTex_TexelSize.x, -_MainTex_TexelSize.y)).rgb;
                float3 br = tex2D(_MainTex, uv + float2(_MainTex_TexelSize.x, -_MainTex_TexelSize.y)).rgb;
                float3 bl = tex2D(_MainTex, uv + float2(_MainTex_TexelSize.x, -_MainTex_TexelSize.y)).rgb;

                float h = getIntensity(tr)
                        + getIntensity(mr) * 2.0
                        + getIntensity(br)
                        - getIntensity(tl)
                        - getIntensity(ml) * 2.0
                        - getIntensity(bl);

                float v = getIntensity(bl)
                        + getIntensity(bc) * 2.0
                        + getIntensity(br)
                        - getIntensity(tl)
                        - getIntensity(tc) * 2.0
                        - getIntensity(tr);

                float c = length(float2(h,v));

                c *= 1.5;
                
                return float4(c, c, c, 1.0);
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma multi_compile _ _Active

            #include "UnityCG.cginc"
            #include "_hlsl/Common.hlsl"

            sampler2D _SobelTex;
            sampler2D _MainTex;
            float _GlobalTime;
            float _ApplyValue;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float3 noise = cyclic(float3(i.uv * 3.0, floor(_GlobalTime * 8.0)), 2.0);
                
                return tex2D(_MainTex, i.uv) + tex2D(_SobelTex, i.uv + noise.xy * 0.03) * _ApplyValue;
            }
            ENDCG
        }
    }
}
