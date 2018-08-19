// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32724,y:32693,varname:node_4795,prsc:2|emission-2393-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:32235,y:32605,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:73877f931885d6943a14beff842a0e22,ntxv:0,isnm:False|UVIN-3640-OUT;n:type:ShaderForge.SFN_Multiply,id:2393,x:32495,y:32793,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-9248-OUT,E-6529-OUT;n:type:ShaderForge.SFN_VertexColor,id:2053,x:32235,y:32776,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:32235,y:32930,ptovrint:True,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Vector1,id:9248,x:32235,y:33081,varname:node_9248,prsc:2,v1:2;n:type:ShaderForge.SFN_ValueProperty,id:4617,x:31594,y:32887,ptovrint:False,ptlb:U Speed (Main),ptin:_USpeedMain,varname:node_4617,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:3848,x:31578,y:33028,ptovrint:False,ptlb:V Speed (Main),ptin:_VSpeedMain,varname:node_3848,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Append,id:4610,x:31819,y:32962,varname:node_4610,prsc:2|A-4617-OUT,B-3848-OUT;n:type:ShaderForge.SFN_Multiply,id:1454,x:31865,y:32718,varname:node_1454,prsc:2|A-9374-T,B-4610-OUT;n:type:ShaderForge.SFN_Time,id:9374,x:31594,y:32658,varname:node_9374,prsc:2;n:type:ShaderForge.SFN_Add,id:3640,x:32068,y:32718,varname:node_3640,prsc:2|A-8414-OUT,B-1454-OUT;n:type:ShaderForge.SFN_Tex2d,id:8350,x:32099,y:33237,ptovrint:False,ptlb:node_8350,ptin:_node_8350,varname:node_8350,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:4cc6f954f0d735341a67c858ed3c763e,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:6529,x:32498,y:33087,varname:node_6529,prsc:2|A-6074-A,B-8350-R;n:type:ShaderForge.SFN_Time,id:9889,x:30531,y:32494,varname:node_9889,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:235,x:30656,y:32775,ptovrint:False,ptlb:U Speed (Noise),ptin:_USpeedNoise,varname:node_235,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_ValueProperty,id:4677,x:30668,y:32895,ptovrint:False,ptlb:V Speed (Noise),ptin:_VSpeedNoise,varname:node_4677,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_Append,id:6872,x:30891,y:32760,varname:node_6872,prsc:2|A-235-OUT,B-4677-OUT;n:type:ShaderForge.SFN_Multiply,id:8288,x:30890,y:32467,varname:node_8288,prsc:2|A-9889-T,B-6872-OUT;n:type:ShaderForge.SFN_TexCoord,id:9218,x:30700,y:32272,varname:node_9218,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:3341,x:31100,y:32342,varname:node_3341,prsc:2|A-9218-UVOUT,B-8288-OUT;n:type:ShaderForge.SFN_Tex2d,id:6359,x:31356,y:32298,ptovrint:False,ptlb:node_6359,ptin:_node_6359,varname:node_6359,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c4906e3c10092184d9c42285b891dfab,ntxv:0,isnm:False|UVIN-3341-OUT;n:type:ShaderForge.SFN_Lerp,id:8414,x:31677,y:32213,varname:node_8414,prsc:2|A-6250-UVOUT,B-6359-R,T-9683-OUT;n:type:ShaderForge.SFN_Slider,id:9683,x:31137,y:32717,ptovrint:False,ptlb:Noise Amount,ptin:_NoiseAmount,varname:node_9683,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_TexCoord,id:6250,x:31284,y:32037,varname:node_6250,prsc:2,uv:0,uaff:False;proporder:6074-797-4617-3848-8350-235-4677-6359-9683;pass:END;sub:END;*/

Shader "Shader Forge/Additive Particle Shader" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("Color", Color) = (0.5,0.5,0.5,1)
        _USpeedMain ("U Speed (Main)", Float ) = 1
        _VSpeedMain ("V Speed (Main)", Float ) = 1
        _node_8350 ("node_8350", 2D) = "white" {}
        _USpeedNoise ("U Speed (Noise)", Float ) = 0.1
        _VSpeedNoise ("V Speed (Noise)", Float ) = 0.1
        _node_6359 ("node_6359", 2D) = "white" {}
        _NoiseAmount ("Noise Amount", Range(0, 1)) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _TintColor;
            uniform float _USpeedMain;
            uniform float _VSpeedMain;
            uniform sampler2D _node_8350; uniform float4 _node_8350_ST;
            uniform float _USpeedNoise;
            uniform float _VSpeedNoise;
            uniform sampler2D _node_6359; uniform float4 _node_6359_ST;
            uniform float _NoiseAmount;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 node_9889 = _Time;
                float2 node_3341 = (i.uv0+(node_9889.g*float2(_USpeedNoise,_VSpeedNoise)));
                float4 _node_6359_var = tex2D(_node_6359,TRANSFORM_TEX(node_3341, _node_6359));
                float4 node_9374 = _Time;
                float2 node_3640 = (lerp(i.uv0,float2(_node_6359_var.r,_node_6359_var.r),_NoiseAmount)+(node_9374.g*float2(_USpeedMain,_VSpeedMain)));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(node_3640, _MainTex));
                float4 _node_8350_var = tex2D(_node_8350,TRANSFORM_TEX(i.uv0, _node_8350));
                float3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*2.0*(_MainTex_var.a*_node_8350_var.r));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG_COLOR(i.fogCoord, finalRGBA, fixed4(0.5,0.5,0.5,1));
                return finalRGBA;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
