Copyright NVIDIA Corporation 2002
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THIS SOFTWARE IS PROVIDED
*AS IS* AND NVIDIA AND ITS SUPPLIERS DISCLAIM ALL WARRANTIES, EITHER EXPRESS
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS FOR A PARTICULAR PURPOSE.  IN NO EVENT SHALL NVIDIA OR ITS SUPPLIERS
BE LIABLE FOR ANY SPECIAL, INCIDENTAL, INDIRECT, OR CONSEQUENTIAL DAMAGES
WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR ANY OTHER PECUNIARY LOSS)
ARISING OUT OF THE USE OF OR INABILITY TO USE THIS SOFTWARE, EVEN IF NVIDIA HAS
BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.


Comments:

sgreen 5/02/02:

This is based on Perlin's original code:
    http://mrl.nyu.edu/~perlin/doc/oscar.html

    It combines the permutation and gradient tables into one array of
    vec4's to conserve constant memory.
    The table is duplicated twice to avoid modulo operations.

jallen@nvidia.com: 10/12/03:

    GLSL version of Cg vertex noise shader

Notes:

    Should use separate tables for 1, 2 and 3D versions

******************************************************************************/

#define B  32      // table size
#define B2 66      // B*2 + 2
#define BR 0.03125 // 1 / B

// this is the smoothstep function f(t) = 3t^2 - 2t^3, without the normalization
vec3 s_curve(vec3 t)
{
    return t*t*( vec3(3.0, 3.0, 3.0) - vec3(2.0, 2.0, 2.0)*t);
}

vec2 s_curve(vec2 t)
{
    return t*t*( vec2(3.0, 3.0) - vec2(2.0, 2.0)*t);
}

float s_curve(float t)
{
    return t*t*(3.0-2.0*t);
}

// 3D version
float noise(vec3 v, vec4 pg[])
{
    v = v + vec3(10000.0, 10000.0, 10000.0);   // hack to avoid negative numbers

    vec3 i = fract(v * BR) * float(B);   // index between 0 and B-1
    vec3 f = fract(v);            // fractional position

    // lookup in permutation table
    vec2 p;
    p.x = pg[ int(i[0])     ].w;
    p.y = pg[ int(i[0]) + 1 ].w;
    p = p + i[1];

    vec4 b;
    b.x = pg[ int(p[0]) ].w;
    b.y = pg[ int(p[1]) ].w;
    b.z = pg[ int(p[0]) + 1 ].w;
    b.w = pg[ int(p[1]) + 1 ].w;
    b = b + i[2];

    // compute dot products between gradients and vectors
    vec4 r;
    r[0] = dot( pg[ int(b[0]) ].xyz, f );
    r[1] = dot( pg[ int(b[1]) ].xyz, f - vec3(1.0, 0.0, 0.0) );
    r[2] = dot( pg[ int(b[2]) ].xyz, f - vec3(0.0, 1.0, 0.0) );
    r[3] = dot( pg[ int(b[3]) ].xyz, f - vec3(1.0, 1.0, 0.0) );

    vec4 r1;
    r1[0] = dot( pg[ int(b[0]) + 1 ].xyz, f - vec3(0.0, 0.0, 1.0) );
    r1[1] = dot( pg[ int(b[1]) + 1 ].xyz, f - vec3(1.0, 0.0, 1.0) );
    r1[2] = dot( pg[ int(b[2]) + 1 ].xyz, f - vec3(0.0, 1.0, 1.0) );
    r1[3] = dot( pg[ int(b[3]) + 1 ].xyz, f - vec3(1.0, 1.0, 1.0) );

    // interpolate
    f = s_curve(f);
    r = mix( r, r1, f[2] );
    r = mix( r.xyyy, r.zwww, f[1] );
    return mix( r.x, r.y, f[0] );
}

// 2D version
float noise(vec2 v, vec4 pg[])
{
    v = v + vec2(10000.0, 10000.0);

    vec2 i = fract(v * BR) * float(B);   // index between 0 and B-1
    vec2 f = fract(v);            // fractional position

    // lookup in permutation table
    vec2 p;
    p[0] = pg[ int(i[0])   ].w;
    p[1] = pg[ int(i[0]) + 1 ].w;
    p = p + i[1];

    // compute dot products between gradients and vectors
    vec4 r;
    r[0] = dot( pg[ int(p[0]) ].xy,   f);
    r[1] = dot( pg[ int(p[1]) ].xy,   f - vec2(1.0, 0.0) );
    r[2] = dot( pg[ int(p[0]) + 1 ].xy, f - vec2(0.0, 1.0) );
    r[3] = dot( pg[ int(p[1]) + 1 ].xy, f - vec2(1.0, 1.0) );

    // interpolate
    f = s_curve(f);
    r = mix( r.xyyy, r.zwww, f[1] );
    return mix( r.x, r.y, f[0] );
}

// 1D version
float noise(float v, vec4 pg[])
{
    v = v + 10000.0;

    float i = fract(v * BR) * float(B);   // index between 0 and B-1
    float f = fract(v);            // fractional position

    // compute dot products between gradients and vectors
    vec2 r;
    r[0] = pg[int(i)].x * f;
    r[1] = pg[int(i) + 1].x * (f - 1.0);

    // interpolate
    f = s_curve(f);
    return mix( r[0], r[1], f);
}

uniform float Displacement;
uniform vec4 pg[B2];            // permutation/gradient table

void main()
{
    // Noise Table
	vec4 pg[B2];
	nTab[0]=vec4(-0.569811,0.432591,-0.698699,0.0);	nTab[1]=vec4(0.78118,0.163006,0.60265,1.0);
	nTab[2]=vec4(0.436394,-0.297978,0.848982,2.0);		nTab[3]=vec4(0.843762,-0.185742,-0.503554,3.0);
	nTab[4]=vec4(0.663712,-0.68443,-0.301731,4.0);		nTab[5]=vec4(0.616757,0.768825,0.168875,5.0);
	nTab[6]=vec4(0.457153,-0.884439,-0.093694,6.0);	nTab[7]=vec4(-0.956955,0.110962,-0.268189,7.0);
	nTab[8]=vec4(0.115821,0.77523,0.620971,8.0);		nTab[9]=vec4(-0.716028,-0.477247,-0.50945,9.0);
	nTab[10]=vec4(0.819593,-0.123834,0.559404,10.0);	nTab[11]=vec4(-0.522782,-0.586534,0.618609,11.0);
	nTab[12]=vec4(-0.792328,-0.577495,-0.196765,12.0);	nTab[13]=vec4(-0.674422,0.0572986,0.736119,13.0);
	nTab[14]=vec4(-0.224769,-0.764775,-0.60382,14.0);	nTab[15]=vec4(0.492662,-0.71614,0.494396,15.0);
	nTab[16]=vec4(0.470993,-0.645816,0.600905,16.0);	nTab[17]=vec4(-0.19049,0.321113,0.927685,17.0);
	nTab[18]=vec4(0.0122118,0.946426,-0.32269,18.0);	nTab[19]=vec4(0.577419,0.408182,0.707089,19.0);
	nTab[20]=vec4(-0.0945428,0.341843,-0.934989,20.0);	nTab[21]=vec4(0.788332,-0.60845,-0.0912217,21.0);
	nTab[22]=vec4(-0.346889,0.894997,-0.280445,22.0);	nTab[23]=vec4(-0.165907,-0.649857,0.741728,23.0);
	nTab[24]=vec4(0.791885,0.124138,0.597919,24.0);	nTab[25]=vec4(-0.625952,0.73148,0.270409,25.0);	nTab[26]=vec4(-0.556306,0.580363,0.594729,26.0);	nTab[27]=vec4(0.673523,0.719805,0.168069,27.0);
	nTab[28]=vec4(-0.420334,0.894265,0.153656,28.0);	nTab[29]=vec4(-0.141622,-0.279389,0.949676,29.0);
	nTab[30]=vec4(-0.803343,0.458278,0.380291,30.0);	nTab[31]=vec4(0.49355,-0.402088,0.77119,31.0);
	nTab[32]=vec4(-0.569811,0.432591,-0.698699,0.0);	nTab[33]=vec4(0.78118,0.163006,0.60265,1.0);
	nTab[34]=vec4(0.436394,-0.297978,0.848982,2.0);	nTab[35]=vec4(0.843762,-0.185742,-0.503554,3.0);
	nTab[36]=vec4(0.663712,-0.68443,-0.301731,4.0);	nTab[37]=vec4(0.616757,0.768825,0.168875,5.0);
	nTab[38]=vec4(0.457153,-0.884439,-0.093694,6.0);	nTab[39]=vec4(-0.956955,0.110962,-0.268189,7.0);
	nTab[40]=vec4(0.115821,0.77523,0.620971,8.0);		nTab[41]=vec4(-0.716028,-0.477247,-0.50945,9.0); 
	nTab[42]=vec4(0.819593,-0.123834,0.559404,10.0);	nTab[43]=vec4(-0.522782,-0.586534,0.618609,11.0); 
	nTab[44]=vec4(-0.792328,-0.577495,-0.196765,12.0);	nTab[45]=vec4(-0.674422,0.0572986,0.736119,13.0); 
	nTab[46]=vec4(-0.224769,-0.764775,-0.60382,14.0);	nTab[47]=vec4(0.492662,-0.71614,0.494396,15.0); 
	nTab[48]=vec4(0.470993,-0.645816,0.600905,16.0);	nTab[49]=vec4(-0.19049,0.321113,0.927685,17.0); 
	nTab[50]=vec4(0.0122118,0.946426,-0.32269,18.0);	nTab[51]=vec4(0.577419,0.408182,0.707089,19.0); 
	nTab[52]=vec4(-0.0945428,0.341843,-0.934989,20.0);	nTab[53]=vec4(0.788332,-0.60845,-0.0912217,21.0); 
	nTab[54]=vec4(-0.346889,0.894997,-0.280445,22.0);	nTab[55]=vec4(-0.165907,-0.649857,0.741728,23.0); 
	nTab[56]=vec4(0.791885,0.124138,0.597919,24.0);	nTab[57]=vec4(-0.625952,0.73148,0.270409,25.0); 
	nTab[58]=vec4(-0.556306,0.580363,0.594729,26.0);	nTab[59]=vec4(0.673523,0.719805,0.168069,27.0);
	nTab[60]=vec4(-0.420334,0.894265,0.153656,28.0);	nTab[61]=vec4(-0.141622,-0.279389,0.949676,29.0); 
	nTab[62]=vec4(-0.803343,0.458278,0.380291,30.0);	nTab[63]=vec4(0.49355,-0.402088,0.77119,31.0); 
	nTab[64]=vec4(-0.569811,0.432591,-0.698699,0.0);	nTab[65]=vec4(0.78118,0.163006,0.60265,1.0);
	
    
    
    vec4 noisePos = gl_TextureMatrix[0] * gl_Vertex;

    float i = (noise(noisePos.xyz, pg) + 1.0) * 0.5;
    gl_FrontColor = vec4(i, i, i, 1.0);

    // displacement along normal
    vec4 position = gl_Vertex + (vec4(gl_Normal, 1.0) * i * Displacement);
    position.w = 1.0;

    gl_Position = gl_ModelViewProjectionMatrix * position;
}