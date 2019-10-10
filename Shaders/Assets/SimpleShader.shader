Shader "Unlit/SimpleShader"
{
    Properties
    {
		_Color ( "Color", Color ) = (1,1,1,1)
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv0 : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv0 : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
				o.uv0 = v.uv0;
				o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

			float4 _Color;

            float4 frag (VertexOutput i) : SV_Target
            {
				float2 uv = i.uv0;
				
				//lightning
				float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;
				float lightFalloff = max(0, dot(lightDir, i.normal));
				float3 directDiffuseLight = lightColor * lightFalloff;

				//Ambient Light
				float3 ambientLight = float3(0.1, 0.1, 0.1);

				//Composite
				float3 diffuseLight = directDiffuseLight + ambientLight;
				float3 compositeLight = diffuseLight * _Color;
                
				return float4(compositeLight ,0);
            }
            ENDCG
        }
    }
}
