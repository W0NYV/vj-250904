Shader "Hidden/Logo"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LogoTex ("Logo Texture", 2D) = "white" {}
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

            sampler2D _MainTex;
            sampler2D _LogoTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 logo = tex2D(_LogoTex, i.uv);

                return float4(abs(logo.rgb - col.rgb), 1.0);
            }
            ENDCG
        }
    }
}
