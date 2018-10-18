// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpriteGlow"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_GlowTexture("Glow Texture", 2D) = "white" {}
		_GlowTint("Glow Tint", Color) = (0,0,0,0)
		_GlowIntensity("Glow Intensity", Range( 0 , 1)) = 0
		_BaseTexture("Base Texture", 2D) = "white" {}
		[Toggle(ETC1_EXTERNAL_ALPHA)] _Keyword0("Keyword 0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform float4 _GlowTint;
			uniform sampler2D _GlowTexture;
			uniform float4 _GlowTexture_ST;
			uniform float _GlowIntensity;
			uniform sampler2D _BaseTexture;
			uniform float4 _BaseTexture_ST;
			uniform float4 _MainTex_ST;
			uniform float4 _AlphaTex_ST;
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv_GlowTexture = IN.texcoord.xy * _GlowTexture_ST.xy + _GlowTexture_ST.zw;
				float4 temp_output_35_0 = ( _GlowTint * tex2D( _GlowTexture, uv_GlowTexture ) * _GlowIntensity );
				float2 uv_BaseTexture = IN.texcoord.xy * _BaseTexture_ST.xy + _BaseTexture_ST.zw;
				float4 tex2DNode37 = tex2D( _BaseTexture, uv_BaseTexture );
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
				float2 uv_AlphaTex = IN.texcoord.xy * _AlphaTex_ST.xy + _AlphaTex_ST.zw;
				float lerpResult43 = lerp( tex2DNode2.a , tex2D( _AlphaTex, uv_AlphaTex ).a , _EnableExternalAlpha);
				#ifdef ETC1_EXTERNAL_ALPHA
				float staticSwitch39 = lerpResult43;
				#else
				float staticSwitch39 = tex2DNode2.a;
				#endif
				float temp_output_44_0 = ( tex2DNode37.a * staticSwitch39 );
				float4 appendResult6 = (float4((( (temp_output_35_0).rgb + ( ( (tex2DNode37).rgb * (tex2DNode2).rgb ) * temp_output_44_0 ) )).xyz , max( (temp_output_35_0).a , temp_output_44_0 )));
				
				fixed4 c = ( IN.color * appendResult6 );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15306
457;92;913;714;1345.437;883.0292;1.018285;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;40;-1557.139,113.5181;Float;False;0;0;_AlphaTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-1539.516,-76.90862;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-1358.238,97.91805;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;42;-1310.139,303.318;Float;False;0;0;_EnableExternalAlpha;Pass;0;5;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1354.082,-91.04765;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-1021.537,172.0178;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-1317.284,-503.181;Float;True;Property;_BaseTexture;Base Texture;3;0;Create;True;0;0;False;0;None;b546f263f4f69a048a8c52bc16da5af0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-1008,-1152;Float;False;Property;_GlowTint;Glow Tint;1;0;Create;True;0;0;False;0;0,0,0,0;0,0.6677432,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-1056,-784;Float;False;Property;_GlowIntensity;Glow Intensity;2;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;39;-860.8315,20.16942;Float;False;Property;_Keyword0;Keyword 0;4;0;Fetch;True;0;0;False;0;0;0;0;True;ETC1_EXTERNAL_ALPHA;Toggle;2;Key0;Key1;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;32;-999.6749,-103.7436;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;20;-1088,-976;Float;True;Property;_GlowTexture;Glow Texture;0;0;Create;True;0;0;False;0;None;1881a54caf1097b408d4db899ef7fadf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;45;-970.4349,-508.2184;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-752,-976;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-600.0481,-128.9198;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-760.1426,-366.8315;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-445.8028,-255.6362;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;30;-560,-992;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;36;-560,-896;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;28;-209.9919,-189.0095;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-185.6511,-626.1651;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;24;40.2133,-547.02;Float;True;True;True;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;125.2029,-273.0999;Float;True;False;False;False;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;524.1426,-653.6168;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;6;485.8951,-392.4319;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;686.4125,-449.3412;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;945.8473,-464.5334;Float;False;True;2;Float;ASEMaterialInspector;0;4;SpriteGlow;0f8ba0101102bb14ebf021ddadce9b49;0;0;;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent;IgnoreProjector=True;RenderType=Transparent;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;0;0;False;False;False;False;False;False;False;False;False;True;2;0;0;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;41;0;40;0
WireConnection;2;0;1;0
WireConnection;43;0;2;4
WireConnection;43;1;41;4
WireConnection;43;2;42;0
WireConnection;39;1;2;4
WireConnection;39;0;43;0
WireConnection;32;0;2;0
WireConnection;45;0;37;0
WireConnection;35;0;33;0
WireConnection;35;1;20;0
WireConnection;35;2;34;0
WireConnection;44;0;37;4
WireConnection;44;1;39;0
WireConnection;38;0;45;0
WireConnection;38;1;32;0
WireConnection;31;0;38;0
WireConnection;31;1;44;0
WireConnection;30;0;35;0
WireConnection;36;0;35;0
WireConnection;28;0;36;0
WireConnection;28;1;44;0
WireConnection;21;0;30;0
WireConnection;21;1;31;0
WireConnection;24;0;21;0
WireConnection;25;0;28;0
WireConnection;6;0;24;0
WireConnection;6;3;25;0
WireConnection;13;0;12;0
WireConnection;13;1;6;0
WireConnection;0;0;13;0
ASEEND*/
//CHKSM=67DA376BB73D97561E379242CDC758C3C7BDE850