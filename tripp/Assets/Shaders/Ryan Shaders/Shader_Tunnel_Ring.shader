// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyAmplifyShaders/Tunnel Ring 01"
{
	Properties
	{
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_RingColor("Ring Color", Color) = (1,0,0,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_RingDissolveAmount("Ring Dissolve Amount", Range( 0 , 1)) = 0.784458
		_VSpeedRings("V Speed (Rings)", Float) = 0.2
		_USpeedRings("U Speed (Rings)", Float) = 0
		_Float0("Float 0", Float) = 5
		_RingTileAmount("Ring Tile Amount", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _RingColor;
		uniform sampler2D _NoiseTex;
		uniform float _RingTileAmount;
		uniform float _USpeedRings;
		uniform float _VSpeedRings;
		uniform sampler2D _TextureSample0;
		uniform float _Float0;
		uniform float _RingDissolveAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = _RingColor.rgb;
			float2 temp_cast_1 = (_RingTileAmount).xx;
			float2 uv_TexCoord20 = i.uv_texcoord * temp_cast_1;
			float4 appendResult17 = (float4(_USpeedRings , _VSpeedRings , 0.0 , 0.0));
			float2 temp_cast_4 = (_Float0).xx;
			float2 uv_TexCoord41 = i.uv_texcoord * temp_cast_4;
			o.Alpha = ( tex2D( _NoiseTex, ( float4( uv_TexCoord20, 0.0 , 0.0 ) + ( _Time.y * appendResult17 ) ).xy ) * ( tex2D( _TextureSample0, uv_TexCoord41 ).a + (-0.6 + (( 1.0 - _RingDissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
1338;23;1215;1010;2351.143;1034.015;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-1926.961,-105.4107;Float;False;Property;_VSpeedRings;V Speed (Rings);6;0;Create;True;0;0;False;0;0.2;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1927.134,-237.019;Float;False;Property;_USpeedRings;U Speed (Rings);7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1523.625,-822.0082;Float;False;Property;_RingTileAmount;Ring Tile Amount;9;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1994.542,-750.6028;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1629.187,-158.2158;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1461.597,49.25905;Float;False;Property;_RingDissolveAmount;Ring Dissolve Amount;5;0;Create;True;0;0;False;0;0.784458;0.6655442;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;19;-1700.562,-417.5938;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-1197.011,-652.1492;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;14;-1142.822,81.55718;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1384.403,-258.1629;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1667.928,-580.7438;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-969.6249,-348.1855;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1;-1097.962,-169.1255;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;8e7b5240e67e0bf4787941cd5fa05026;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;15;-910.1226,98.45606;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-809.4333,-418.5532;Float;True;Property;_NoiseTex;Noise Tex;0;0;Create;True;0;0;False;0;c4906e3c10092184d9c42285b891dfab;b12ef3a3a7889dd47980c98933d71df9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-674.5687,-86.71671;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;36;-573.129,589.0693;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-733.1287,589.0693;Float;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-317.1292,445.0692;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;37;-573.129,429.0692;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;34;-925.1287,589.0693;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;30;-1581.128,701.0693;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-386.5131,-172.2424;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-225.0127,-551.4286;Float;False;Property;_RingColor;Ring Color;2;0;Create;True;0;0;False;0;1,0,0,0;0.4864878,0,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;31;-1581.128,557.0693;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-1101.129,589.0693;Float;False;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1086.45,733.2999;Float;False;Property;_ExtrusionAmount;Extrusion Amount;3;0;Create;True;0;0;False;0;0.5;13.5;-1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1325.128,589.0693;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1329.322,722.8149;Float;False;Property;_ExtrusionPoint;ExtrusionPoint;1;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;93.81293,-269.5672;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyAmplifyShaders/Tunnel Ring 01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;18;0
WireConnection;17;1;16;0
WireConnection;20;0;25;0
WireConnection;14;0;13;0
WireConnection;21;0;19;0
WireConnection;21;1;17;0
WireConnection;41;0;42;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;1;1;41;0
WireConnection;15;0;14;0
WireConnection;23;1;22;0
WireConnection;10;0;1;4
WireConnection;10;1;15;0
WireConnection;36;0;35;0
WireConnection;35;0;34;0
WireConnection;35;1;40;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;34;0;33;0
WireConnection;29;0;23;0
WireConnection;29;1;10;0
WireConnection;33;0;32;0
WireConnection;33;1;39;0
WireConnection;32;0;31;2
WireConnection;32;1;30;1
WireConnection;0;2;9;0
WireConnection;0;9;29;0
ASEEND*/
//CHKSM=68FE733342B9FFD4923B27FCF76442D84306291E