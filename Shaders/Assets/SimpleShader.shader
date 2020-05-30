Shader "Unlit/SimpleShader"
{
    Properties
    {
		_Color ( "Color", Color ) = (1,1,1,1)
		_Gloss ( "Gloss", Float ) = 1
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
				float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Gloss;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
				o.uv0 = v.uv0;
				o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

			float4 _Color;

            float4 frag (VertexOutput i) : SV_Target
            {
				float2 uv = i.uv0;
                float3 normal = normalize(i.normal);

                float3 lightDir = _WorldSpaceLightPos0.xyz;
				float3 lightColor = _LightColor0.rgb;

				//Direct diffuse light				
				float lightFalloff = max(0, dot(lightDir, normal));
                //lightFalloff = step(0.1, lightFalloff);
				float3 directDiffuseLight = lightColor * lightFalloff;

				//Ambient Light
				float3 ambientLight = float3(0.1, 0.1, 0.1);

                //Direct speculat light
                float3 camPos = _WorldSpaceCameraPos;
                float3 fragToCam = camPos - i.worldPos;
                float3 viewDir = normalize(fragToCam);
                //return float4(viewDir, 1);

                //Phong
                //Bling-Phong
                float3 viewReflect = reflect(-viewDir, normal);
                float3 specularFalloff = max(0, dot(lightDir, viewReflect));
                specularFalloff = pow(specularFalloff, _Gloss);
                //specularFalloff = step(0.1, specularFalloff);

                float3 directSpecular = specularFalloff * lightColor;
                //return float4(directSpecular, 0);

				//Composite
				float3 diffuseLight = directDiffuseLight + ambientLight;
				float3 compositeLight = diffuseLight * _Color + directSpecular;
                
				return float4(compositeLight ,0);
            }
            ENDCG
        }
    }
}
