Shader /*ase_name*/ "ASETemplateShaders/LightWeightSRPPBR" /*end*/
{
	Properties
	{
		/*ase_props*/
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "LightweightPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		/*ase_pass*/
		Pass
		{
			/*ase_pass_options:Name=Misc Options
				Option,_FinalColorxAlpha:Final Color x Alpha:true,false
					true:SetDefine:ASE_LW_FINAL_COLOR_ALPHA_MULTIPLY 1
			*/
			Tags
			{
				"LightMode" = "LightweightForward"
			}
			Name "Base"
			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
			/*ase_stencil*/
			HLSLPROGRAM
		    // Required to compile gles 2.0 with standard srp library
		    #pragma prefer_hlslcc gles
			
			// -------------------------------------
			// Lightweight Pipeline keywords
			#pragma multi_compile _ _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _VERTEX_LIGHTS
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ _SHADOWS_ENABLED
			#pragma multi_compile _ _LOCAL_SHADOWS_ENABLED
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _SHADOWS_CASCADE
			#pragma multi_compile _ FOG_LINEAR FOG_EXP2
		
			// -------------------------------------
			// Unity defined keywords
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
		
			//--------------------------------------
			// GPU Instancing
			#pragma multi_compile_instancing
		
		    #pragma vertex vert
			#pragma fragment frag
		
			/*ase_pragma*/

			#include "LWRP/ShaderLibrary/Core.hlsl"
			#include "LWRP/ShaderLibrary/Lighting.hlsl"
			#include "CoreRP/ShaderLibrary/Color.hlsl"
			#include "CoreRP/ShaderLibrary/UnityInstancing.hlsl"
			#include "ShaderGraphLibrary/Functions.hlsl"	
			
			/*ase_globals*/
					
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				/*ase_vdata:p=p;n=n;t=t;uv1=tc1.xyzw*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos					: SV_POSITION;
				float4 lightmapUVOrVertexSH		: TEXCOORD0;
				half4 fogFactorAndVertexLight	: TEXCOORD1; 
				float4 shadowCoord				: TEXCOORD2;
				float4 tSpace0					: TEXCOORD3;
				float4 tSpace1					: TEXCOORD4;
				float4 tSpace2					: TEXCOORD5;
				float3 WorldSpaceViewDirection	: TEXCOORD6;
				/*ase_interp(7,):sp=sp.xyzw;wn.x=tc3.z;wn.y=tc4.z;wn.z=tc5.z;wt.x=tc3.x;wt.y=tc4.x;wt.z=tc5.x;wbt.x=tc3.y;wbt.y=tc4.y;wbt.z=tc5.y;wp.x=tc3.w;wp.y=tc4.w;wp.z=tc5.w;wvd=tc6*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			GraphVertexOutput vert (GraphVertexInput v/*ase_vert_input*/)
			{
		        GraphVertexOutput o = (GraphVertexOutput)0;
		
		        UNITY_SETUP_INSTANCE_ID(v);
		    	UNITY_TRANSFER_INSTANCE_ID(v, o);
		
				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;8;-1;_Vertex*/ float3( 0, 0, 0 ) /*end*/;
				v.ase_normal = /*ase_vert_out:Vertex Normal;Float3;10;-1;_Normal*/ v.ase_normal /*end*/;

				float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);
				float4 clipPos = TransformWorldToHClip(lwWorldPos);

				clipPos = TransformWorldToHClip(TransformObjectToWorld(v.vertex.xyz));
				OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH);
				OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH);

				half3 vertexLight = VertexLighting(lwWorldPos, lwWNormal);
				half fogFactor = ComputeFogFactor(clipPos.z);
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				o.clipPos = clipPos;

				#ifdef _SHADOWS_ENABLED
				#if SHADOWS_SCREEN
					o.shadowCoord = ComputeShadowCoord ( clipPos );
				#else
					o.shadowCoord = TransformWorldToShadowCoord ( lwWorldPos );
				#endif
				#endif

				return o;
			}
		
			half4 frag (GraphVertexOutput IN /*ase_frag_input*/) : SV_Target
		    {
		    	UNITY_SETUP_INSTANCE_ID(IN);
		
				/*ase_local_var:wn*/float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				/*ase_local_var:wt*/float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				/*ase_local_var:wbt*/float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				/*ase_local_var:wp*/float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				/*ase_local_var:wvd*/float3 WorldSpaceViewDirection = SafeNormalize( _WorldSpaceCameraPos.xyz  - WorldSpacePosition );

				/*ase_frag_code:IN=GraphVertexOutput*/
				
		        float3 Albedo = /*ase_frag_out:Albedo;Float3;0*/float3(0.5, 0.5, 0.5)/*end*/;
				float3 Normal = /*ase_frag_out:Normal;Float3;1*/float3(0, 0, 1)/*end*/;
				float3 Emission = /*ase_frag_out:Emission;Float3;2*/0/*end*/;
				float3 Specular = /*ase_frag_out:Specular;Float3;9*/float3(0.5, 0.5, 0.5)/*end*/;
				float Metallic = /*ase_frag_out:Metallic;Float;3*/0/*end*/;
				float Smoothness = /*ase_frag_out:Smoothness;Float;4*/0.5/*end*/;
				float Occlusion = /*ase_frag_out:Occlusion;Float;5*/1/*end*/;
				float Alpha = /*ase_frag_out:Alpha;Float;6;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;7;-1;_AlphaClip*/0/*end*/;
		
				InputData inputData;
				inputData.positionWS = WorldSpacePosition;

				#ifdef _NORMALMAP
					inputData.normalWS = TangentToWorldNormal(Normal, WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal);
				#else
					#if !SHADER_HINT_NICE_QUALITY
						inputData.normalWS = WorldSpaceNormal;
					#else
						inputData.normalWS = normalize ( WorldSpaceNormal );
					#endif
				#endif

				#if !SHADER_HINT_NICE_QUALITY
					// viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
					inputData.viewDirectionWS = WorldSpaceViewDirection;
				#else
					inputData.viewDirectionWS = normalize ( WorldSpaceViewDirection );
				#endif

				inputData.shadowCoord = IN.shadowCoord;

				inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH, IN.lightmapUVOrVertexSH, inputData.normalWS);

				half4 color = LightweightFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				// Computes fog factor per-vertex
#ifdef TERRAIN_SPLAT_ADDPASS
				ApplyFogColor( color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
#else
				ApplyFog( color.rgb, IN.fogFactorAndVertexLight.x );
#endif
    			
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
#if ASE_LW_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
#endif
				return color;
		    }
			ENDHLSL
		}

		/*ase_pass*/
		Pass
		{
			/*ase_hide_pass*/
			Name "ShadowCaster"
			Tags{"LightMode" = "ShadowCaster"}

			ZWrite On
			ZTest LEqual

			HLSLPROGRAM
		    #pragma prefer_hlslcc gles
		
			#pragma multi_compile_instancing
		
		    #pragma vertex vert
			#pragma fragment frag
		
			#include "LWRP/ShaderLibrary/Core.hlsl"
			#include "LWRP/ShaderLibrary/Lighting.hlsl"
			/*ase_pragma*/
			uniform float4 _ShadowBias;
			uniform float3 _LightDirection;
			/*ase_globals*/
					
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				/*ase_vdata:p=p;n=n*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos : SV_POSITION;
				/*ase_interp(7,):sp=sp.xyzw;*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			GraphVertexOutput vert (GraphVertexInput v/*ase_vert_input*/)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/

				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;2;-1;_Vertex*/ float3(0,0,0) /*end*/;
				v.ase_normal = /*ase_vert_out:Vertex Normal;Float3;3;-1;_Normal*/ v.ase_normal /*end*/;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
				float scale = invNdotL * _ShadowBias.y;

				positionWS = normalWS * scale.xxx + positionWS;
				float4 clipPos = TransformWorldToHClip(positionWS);

				clipPos.z += _ShadowBias.x;
				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				o.clipPos = clipPos;
				return o;
			}
		
			half4 frag (GraphVertexOutput IN /*ase_frag_input*/) : SV_Target
		    {
		    	UNITY_SETUP_INSTANCE_ID(IN);

				/*ase_frag_code:IN=GraphVertexOutput*/

				float Alpha = /*ase_frag_out:Alpha;Float;0;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;1;-1;_AlphaClip*/AlphaClipThreshold/*end*/;
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				return Alpha;
		    }
			ENDHLSL
		}
		
		/*ase_pass*/
		Pass
		{
			/*ase_hide_pass*/
			Name "DepthOnly"
			Tags{"LightMode" = "DepthOnly"}

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
    
			#pragma multi_compile_instancing

			#pragma vertex vert
			#pragma fragment frag

			#include "LWRP/ShaderLibrary/Core.hlsl"
			#include "LWRP/ShaderLibrary/Lighting.hlsl"
			/*ase_pragma*/
			/*ase_globals*/

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				/*ase_vdata:p=p;n=n*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos : SV_POSITION;
				/*ase_interp(7,):sp=sp.xyzw;*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			GraphVertexOutput vert (GraphVertexInput v/*ase_vert_input*/)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/

				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;2;-1;_Vertex*/ float3(0,0,0) /*end*/;
				v.ase_normal = /*ase_vert_out:Vertex Normal;Float3;3;-1;_Normal*/ v.ase_normal /*end*/;
				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag (GraphVertexOutput IN /*ase_frag_input*/) : SV_Target
		    {
		    	UNITY_SETUP_INSTANCE_ID(IN);

				/*ase_frag_code:IN=GraphVertexOutput*/

				float Alpha = /*ase_frag_out:Alpha;Float;0;-1;_Alpha*/1/*end*/;
				float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;1;-1;_AlphaClip*/AlphaClipThreshold/*end*/;
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				return Alpha;
		    }
			ENDHLSL
		}
		
		/*ase_pass*/
		Pass
		{
			/*ase_hide_pass*/
			Name "Meta"
			Tags{"LightMode" = "Meta"}
			Cull Off

			HLSLPROGRAM
			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles

			#pragma vertex LightweightVertexMeta
			#pragma fragment LightweightFragmentMeta

			#pragma shader_feature _SPECULAR_SETUP
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICSPECGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature EDITOR_VISUALIZATION

			#pragma shader_feature _SPECGLOSSMAP

			#include "LWRP/ShaderLibrary/InputSurfacePBR.hlsl"
			#include "LWRP/ShaderLibrary/LightweightPassMetaPBR.hlsl"
			ENDHLSL
		}
	}
	CustomEditor "ASEMaterialInspector"
}
