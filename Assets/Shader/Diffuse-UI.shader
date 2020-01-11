
Shader "Custom/UI/Diffuse-UI" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _LightColor("Light Color", Color) = (1,1,1,1)
        _LightDir ("Light Position", Vector) = (0,10,0,1)
        _Strength("Light Strength", Range(0,2)) = 0.5
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }

        Pass {
            CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag


                #include "UnityCG.cginc"

                struct a2v {
                    float4 vertex : POSITION;
                    float2 texcoord : TEXCOORD0;
                    float3 normal : NORMAL;
                };

                struct v2f {
                    float4 pos : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 worldNormal : TEXCOORD1;
                    float3 worldPos : TEXCOORD2;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                fixed4 _LightColor;
                float4 _LightDir;
                float _Strength;

                v2f vert (a2v v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.worldNormal = UnityObjectToWorldNormal(v.normal);
                    return o;
                }

                fixed4 frag (v2f i) : SV_Target
                {
                    fixed4 col = tex2D(_MainTex, i.uv);
                    fixed3 worldLight = normalize(-_LightDir.xyz);
                    fixed3 diffuse = _LightColor.rgb * col.rgb * saturate(dot(i.worldNormal,worldLight)) * _Strength;
                    return fixed4(diffuse,1);
                }
            ENDCG
        }
    }
}

