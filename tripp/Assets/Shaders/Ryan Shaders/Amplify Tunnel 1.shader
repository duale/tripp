// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyAmplifyShaders/Tunnel01"
{
	Properties
	{
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0.8352236,0.9716981,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_VSpeedDistort("V Speed (Distort)", Float) = 0.2
		_VSpeedMain("V Speed (Main)", Float) = 0.2
		_USpeedMain("U Speed (Main)", Float) = 0
		_USpeedDistort("U Speed (Distort)", Float) = 0
		_AlphaFade("Alpha Fade", 2D) = "white" {}
		_NoiseAmount("Noise Amount", Range( 0 , 1)) = 1
		_SeamGradient("Seam Gradient", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _GrabTexture;
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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor38 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			o.Albedo = screenColor38.rgb;
			float4 appendResult19 = (float4(_USpeedDistort , _VSpeedDistort , 0.0 , 0.0));
			float2 temp_cast_3 = (tex2D( _NoiseTex, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( _Time.y * appendResult19 ) ).xy ).r).xx;
			float2 lerpResult25 = lerp( i.uv_texcoord , temp_cast_3 , _NoiseAmount);
			float2 uv_SeamGradient = i.uv_texcoord * _SeamGradient_ST.xy + _SeamGradient_ST.zw;
			float2 lerpResult28 = lerp( i.uv_texcoord , lerpResult25 , tex2D( _SeamGradient, uv_SeamGradient ).r);
			float4 appendResult8 = (float4(_USpeedMain , _VSpeedMain , 0.0 , 0.0));
			float2 uv_AlphaFade = i.uv_texcoord * _AlphaFade_ST.xy + _AlphaFade_ST.zw;
			o.Emission = ( ( tex2D( _MainTex, ( float4( lerpResult28, 0.0 , 0.0 ) + ( _Time.y * appendResult8 ) ).xy ).a * tex2D( _AlphaFade, uv_AlphaFade ).r ) * _Color0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
380;164;1245;688;1048.822;385.4911;1.983114;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-3260.451,-470.1986;Float;False;Property;_VSpeedDistort;V Speed (Distort);3;0;Create;True;0;0;False;0;0.2;-0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3250.222,-605.7079;Float;False;Property;_USpeedDistort;U Speed (Distort);6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-2962.677,-523.0037;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-3034.052,-782.382;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2717.893,-622.9509;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2632.181,-855.9667;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2319.928,-707.369;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1672.184,183.5657;Float;False;Property;_USpeedMain;U Speed (Main);5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1679.615,299.4907;Float;False;Property;_VSpeedMain;V Speed (Main);4;0;Create;True;0;0;False;0;0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1826.665,-1093.681;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1940.393,-470.1517;Float;False;Property;_NoiseAmount;Noise Amount;8;0;Create;True;0;0;True;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1996.766,-737.4746;Float;True;Property;_NoiseTex;Noise Tex;0;0;Create;True;0;0;False;0;c4906e3c10092184d9c42285b891dfab;c4906e3c10092184d9c42285b891dfab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;5;-1516.167,-1.501845;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;-1376.734,-758.8129;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-1444.792,257.8767;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-1358.635,-1135.043;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-1389.625,-402.4576;Float;True;Property;_SeamGradient;Seam Gradient;9;0;Create;True;0;0;False;0;None;c49dae98b2bc44e499f845caca0de39d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1200.008,157.9293;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;28;-982.3271,-552.0743;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-990.9462,-34.53849;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1150.148,450.3658;Float;True;Property;_AlphaFade;Alpha Fade;7;0;Create;True;0;0;False;0;4cc6f954f0d735341a67c858ed3c763e;4cc6f954f0d735341a67c858ed3c763e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;13;-772.5474,453.5662;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;4cc6f954f0d735341a67c858ed3c763e;4cc6f954f0d735341a67c858ed3c763e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-636.3225,68.12408;Float;True;Property;_MainTex;Main Tex;2;0;Create;True;0;0;False;0;73877f931885d6943a14beff842a0e22;73877f931885d6943a14beff842a0e22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-298.7482,337.5656;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-300.9492,-116.814;Float;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0.8352236,0.9716981,0;0.972549,0.1648327,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;38;319.2599,-87.33649;Float;False;Global;_GrabScreen0;Grab Screen 0;10;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;33;-825.7109,-100.9342;Float;False;-1;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;72.77259,220.3423;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;782.8345,247.1649;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyAmplifyShaders/Tunnel01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;28;0;31;0
WireConnection;28;1;25;0
WireConnection;28;2;30;1
WireConnection;10;0;28;0
WireConnection;10;1;9;0
WireConnection;13;0;16;0
WireConnection;4;1;10;0
WireConnection;14;0;4;4
WireConnection;14;1;13;1
WireConnection;1;0;14;0
WireConnection;1;1;3;0
WireConnection;0;0;38;0
WireConnection;0;2;1;0
ASEEND*/
//CHKSM=8E2C62F07D147A4A936B54CF136E44B1D75498CA