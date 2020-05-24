Shader "Unlit/1"
{
    Properties
    {
        _Color ( "Color", Color ) = (1,1,1,1)
        _AmbientLightColor ( "Ambient Light Color", Color ) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            //#include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            float4 _Color;
            float4 _AmbientLightColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv0;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float3 lightColor = _LightColor0.rgb;
                
                float3 simpleLight = max(0, dot(lightDir, i.normal));

                float3 directDiffuseLight = lightColor * simpleLight;
                float3 diffuseLight = directDiffuseLight + _AmbientLightColor;
                float3 combined = diffuseLight * _Color;

                return fixed4(combined, 0);
            }
            ENDCG
        }
    }
}
