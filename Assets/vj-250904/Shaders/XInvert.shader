Shader "Hidden/XInvert"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [Toggle(_Active)]Active("Active", Float) = 0
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
            #pragma multi_compile _ _Active

            #include "UnityCG.cginc"
            
            sampler2D _MainTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
#if _Active
                float2 uv = i.uv;
                uv.x -= 0.5;
                uv.x = abs(uv.x);
                
                return tex2D(_MainTex, uv);
#endif

                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
