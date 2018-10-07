Shader /*ase_name*/ "ASETemplateShaders/LightWeightSRPUnlit" /*end*/
{
	Properties
	{
		/*ase_props*/
	}
	
	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue"="Geometry" "RenderPipeline" = "LightweightPipeline"}
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
		/*ase_pass*/
		Pass
		{
			Tags{"LightMode" = "LightweightForward"}
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
		    #pragma exclude_renderers d3d11_9x
		
		    #pragma vertex vert
		    #pragma fragment frag
		
			/*ase_pragma*/

		    // Lighting include is needed because of GI
		    #include "LWRP/ShaderLibrary/Core.hlsl"
		    #include "LWRP/ShaderLibrary/Lighting.hlsl"
		    #include "CoreRP/ShaderLibrary/Color.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
			
			/*ase_globals*/
					
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				/*ase_vdata:p=p;n=n*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
	
		    struct GraphVertexOutput
		    {
		        float4 position : POSITION;
				/*ase_interp(0,):sp=sp.xyzw*/
		        UNITY_VERTEX_INPUT_INSTANCE_ID
		    };
		
		    GraphVertexOutput vert (GraphVertexInput v/*ase_vert_input*/ )
			{
		        GraphVertexOutput o = (GraphVertexOutput)0;
		        UNITY_SETUP_INSTANCE_ID(v);
		        UNITY_TRANSFER_INSTANCE_ID(v, o);
				/*ase_vert_code:v=GraphVertexInput;o=GraphVertexOutput*/
				v.vertex.xyz += /*ase_vert_out:Vertex Offset;Float3;3;-1;_Vertex*/ float3( 0, 0, 0 ) /*end*/;
				v.ase_normal = /*ase_vert_out:Vertex Normal;Float3;4;-1;_Normal*/ v.ase_normal /*end*/;
		        o.position = TransformObjectToHClip(v.vertex.xyz);
		        return o;
			}
		
		    half4 frag (GraphVertexOutput IN) : SV_Target
		    {
		        UNITY_SETUP_INSTANCE_ID(IN);
				/*ase_frag_code:IN=GraphVertexOutput*/
		        float3 Color = /*ase_frag_out:Color;Float3;0*/float3(1,1,1)/*end*/;
		        float Alpha = /*ase_frag_out:Alpha;Float;1;-1;_Alpha*/1/*end*/;
		        float AlphaClipThreshold = /*ase_frag_out:Alpha Clip Threshold;Float;2;-1;_AlphaClip*/0/*end*/;
		#if _AlphaClip
		        clip(Alpha - AlphaClipThreshold);
		#endif
		    	return half4(Color, Alpha);
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
			/*ase_pragma*/
			/*ase_globals*/

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				/*ase_vdata:p=p;n=n*/
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos : SV_POSITION;
				/*ase_interp(0,):sp=sp.xyzw;*/
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
				return 0;
		    }
			ENDHLSL
		}
	}	
	FallBack "Hidden/InternalErrorShader"
}
