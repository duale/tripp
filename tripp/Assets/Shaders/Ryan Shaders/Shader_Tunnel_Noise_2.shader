// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyAmplifyShaders/Tunnel Noise 02"
{
	Properties
	{
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.8352236,0.9716981,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_VSpeedDistort("V Speed (Distort)", Float) = 0.2
		_Float0("Float 0", Float) = 0.2
		_VSpeedMain("V Speed (Main)", Float) = 0.2
		_USpeedMain("U Speed (Main)", Float) = 0
		_USpeedDistort("U Speed (Distort)", Float) = 0
		_Float1("Float 1", Float) = 0
		_AlphaFade("Alpha Fade", 2D) = "white" {}
		_NoiseAmount("Noise Amount", Range( 0 , 1)) = 1
		_SeamGradient("Seam Gradient", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_DissolveAmount("DissolveAmount", Range( 0 , 1)) = 0.7153027
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent-1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
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

		uniform sampler2D _MainTex;
		uniform sampler2D _NoiseTex;
		uniform float _USpeedDistort;
		uniform float _VSpeedDistort;
		uniform float _NoiseAmount;
		uniform sampler2D _SeamGradient;
		uniform float4 _SeamGradient_ST;
		uniform float _USpeedMain;
		uniform float _VSpeedMain;
		uniform sampler2D _AlphaFade;
		uniform float4 _AlphaFade_ST;
		uniform float4 _Color0;
		uniform sampler2D _TextureSample0;
		uniform float _Float1;
		uniform float _Float0;
		uniform float _DissolveAmount;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult19 = (float4(_USpeedDistort , _VSpeedDistort , 0.0 , 0.0));
			float2 temp_cast_2 = (tex2D( _NoiseTex, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( _Time.y * appendResult19 ) ).xy ).r).xx;
			float2 lerpResult25 = lerp( i.uv_texcoord , temp_cast_2 , _NoiseAmount);
			float2 uv_SeamGradient = i.uv_texcoord * _SeamGradient_ST.xy + _SeamGradient_ST.zw;
			float2 lerpResult28 = lerp( i.uv_texcoord , lerpResult25 , tex2D( _SeamGradient, uv_SeamGradient ).r);
			float4 appendResult8 = (float4(_USpeedMain , _VSpeedMain , 0.0 , 0.0));
			float2 uv_AlphaFade = i.uv_texcoord * _AlphaFade_ST.xy + _AlphaFade_ST.zw;
			o.Emission = ( ( tex2D( _MainTex, ( float4( lerpResult28, 0.0 , 0.0 ) + ( _Time.y * appendResult8 ) ).xy ).a * tex2D( _AlphaFade, uv_AlphaFade ) ) * _Color0 ).rgb;
			float4 appendResult58 = (float4(_Float1 , _Float0 , 0.0 , 0.0));
			o.Alpha = ( tex2D( _TextureSample0, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( _Time.y * appendResult58 ) ).xy ) + (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
2014;29;1215;1004;1087.61;164.0974;1.898475;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-3260.451,-470.1986;Float;False;Property;_VSpeedDistort;V Speed (Distort);4;0;Create;True;0;0;False;0;0.2;-0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3250.222,-605.7079;Float;False;Property;_USpeedDistort;U Speed (Distort);10;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-3034.052,-782.382;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-2962.677,-523.0037;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2717.893,-622.9509;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2582.936,-939.4671;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2319.928,-707.369;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1940.393,-470.1517;Float;False;Property;_NoiseAmount;Noise Amount;13;0;Create;True;0;0;True;0;1;0.49;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1679.615,299.4907;Float;False;Property;_VSpeedMain;V Speed (Main);6;0;Create;True;0;0;False;0;0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1826.665,-1093.681;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-1996.766,-737.4746;Float;True;Property;_NoiseTex;Noise Tex;0;0;Create;True;0;0;False;0;c4906e3c10092184d9c42285b891dfab;c4906e3c10092184d9c42285b891dfab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-1672.184,183.5657;Float;False;Property;_USpeedMain;U Speed (Main);9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1924.659,1165.65;Float;False;Property;_Float1;Float 1;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1389.625,-402.4576;Float;True;Property;_SeamGradient;Seam Gradient;14;0;Create;True;0;0;False;0;c49dae98b2bc44e499f845caca0de39d;c49dae98b2bc44e499f845caca0de39d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;25;-1376.734,-758.8129;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-1934.888,1301.16;Float;False;Property;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.2;-0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1358.635,-1135.043;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1516.167,-1.501845;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1444.792,257.8767;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1637.114,1248.354;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;59;-1708.489,988.9763;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1200.008,157.9293;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;28;-982.3271,-552.0743;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1392.33,1148.407;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1150.148,450.3658;Float;True;Property;_AlphaFade;Alpha Fade;12;0;Create;True;0;0;False;0;4cc6f954f0d735341a67c858ed3c763e;888dae9b0c5dc1d46bac53ea3ca2bf23;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-1306.618,915.3916;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-990.9462,-34.53849;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-365.1934,1175.775;Float;False;Property;_DissolveAmount;DissolveAmount;16;0;Create;True;0;0;False;0;0.7153027;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-636.3225,68.12408;Float;True;Property;_MainTex;Main Tex;3;0;Create;True;0;0;False;0;73877f931885d6943a14beff842a0e22;73877f931885d6943a14beff842a0e22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;54;-18.09358,1169.676;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-772.5474,453.5662;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;4cc6f954f0d735341a67c858ed3c763e;4cc6f954f0d735341a67c858ed3c763e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-994.3651,1063.989;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TFHCRemapNode;55;272.6066,1250.575;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-161.5926,-102.1449;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0.8352236,0.9716981,0;0.972549,0,0.7843584,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-298.7482,337.5656;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;50;-185.2136,623.2792;Float;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;e28dc97a9541e3642a48c0e3886688c5;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;33;-599.6081,-300.1733;Float;False;-1;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.ScreenColorNode;38;323.1599,-109.4365;Float;False;Global;_GrabScreen0;Grab Screen 0;10;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;66;-1675.681,1547.951;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1839.129,1848.944;Float;False;Property;_Float2;Float 2;7;0;Create;True;0;0;False;0;0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;72.77259,220.3423;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1604.306,1807.329;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;445.358,828.7156;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;70;898.1904,947.6514;Float;False;Color Mask;-1;;1;eec747d987850564c95bde0e5a6d1867;0;4;1;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1831.698,1733.019;Float;False;Property;_Float3;Float 3;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1150.46,1514.914;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;63;-795.8362,1617.577;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;73877f931885d6943a14beff842a0e22;73877f931885d6943a14beff842a0e22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1359.522,1707.382;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;879.3648,335.1815;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyAmplifyShaders/Tunnel Noise 02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;-1;False;Transparent;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;1;False;-1;10;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;23;0;22;0
WireConnection;23;1;21;0
WireConnection;24;1;23;0
WireConnection;25;0;27;0
WireConnection;25;1;24;1
WireConnection;25;2;26;0
WireConnection;8;0;6;0
WireConnection;8;1;7;0
WireConnection;58;0;57;0
WireConnection;58;1;56;0
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;28;0;31;0
WireConnection;28;1;25;0
WireConnection;28;2;30;1
WireConnection;60;0;59;0
WireConnection;60;1;58;0
WireConnection;10;0;28;0
WireConnection;10;1;9;0
WireConnection;4;1;10;0
WireConnection;54;0;51;0
WireConnection;13;0;16;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;55;0;54;0
WireConnection;14;0;4;4
WireConnection;14;1;13;0
WireConnection;50;1;62;0
WireConnection;1;0;14;0
WireConnection;1;1;3;0
WireConnection;67;0;65;0
WireConnection;67;1;64;0
WireConnection;53;0;50;0
WireConnection;53;1;55;0
WireConnection;69;1;68;0
WireConnection;63;1;69;0
WireConnection;68;0;66;0
WireConnection;68;1;67;0
WireConnection;0;2;1;0
WireConnection;0;9;53;0
ASEEND*/
//CHKSM=655E0A38E31348E7531B4EA578D42FDCE67979B1