--macro.lua

-- lua insanity patches
#define X 1
#define Y 2
#define Z 3
#define W 4
#define XX 1
#define XY 2
#define XZ 3
#define YX 4
#define YY 5
#define YZ 6
#define ZX 7
#define ZY 8
#define ZZ 9
#define TX 10
#define TY 11
#define TZ 12
#define WX 10
#define WY 11
#define WZ 12


--#define MAX(x,y) ((x)>(y) and (x) or (y))
--#define MIN(x,y) ((x)<(y) and (x) or (y))
--#define ABS(x) ((x)<(0) and (0) or (x))
--#define CLAMP(x,a,b) MAX(a,MIN(b,x))

--#define max(x,y) ((x)>(y) and (x) or (y))
--#define min(x,y) ((x)<(y) and (x) or (y))
--#define abs(x) ((x)<(0) and (0) or (x))
#define clamp(x,a,b) MAX(a,MIN(b,x))

local max,min,abs = math.max, math.min, math.abs


--transform to use when processing tons of vertices
local Xx,Xy,Xz,Yx,Yy,Yz,Zx,Zy,Zz,Tx,Ty,Tz = 1.,0.,0.,0.,1.,0.,0.,0.,1.,0.,0.,0.

-- math
local sqrt,flr,cos,sin,rnd=math.sqrt,math.floor,
math.cos,math.sin,math.random

#define tset(m,xx,xy,xz, yx,yy,yz, zx,zy,zz, tx,ty,tz )\
m[XX],m[XY],m[XZ],m[YX],m[YY],m[YZ],m[ZX],m[ZY],m[ZZ],m[TX],m[TY],m[TZ]=\
(xx),(xy),(xz),(yx),(yy),(yz),(zx),(zy),(zz),(tx),(ty),(tz)

-- viewmatrix in local X,Y,Z,T
#define IC_ID()\
Xx= CM[XX]	Xy= CM[YX]	Xz= CM[ZX]\
Yx= CM[XY]	Yy= CM[YY]	Yz= CM[ZY]\
Zx= CM[XZ]	Zy= CM[YZ]	Zz= CM[ZZ]\
Tx = -( Xx*CM[TX] + Yx*CM[TY] + Zx*CM[TZ] )\
Ty = -( Xy*CM[TX] + Yy*CM[TY] + Zy*CM[TZ] )\
Tz = -( Xz*CM[TX] + Yz*CM[TY] + Zz*CM[TZ] )

-- MAT3_MUL
--#define MAT3_MUL(d,m,b) \
function MAT3_MUL(d,m,b)
   d[1]=m[1]*b[X] + m[4]*b[Y] + m[7]*b[Z]
   d[2]=m[2]*b[X] + m[5]*b[Y] + m[8]*b[Z]
   d[3]=m[3]*b[X] + m[6]*b[Y] + m[9]*b[Z]
   d[4]=m[1]*b[4] + m[4]*b[5] + m[7]*b[6]
   d[5]=m[2]*b[4] + m[5]*b[5] + m[8]*b[6]
   d[6]=m[3]*b[4] + m[6]*b[5] + m[9]*b[6]
   d[7]=m[1]*b[7] + m[4]*b[8] + m[7]*b[9]
   d[8]=m[2]*b[7] + m[5]*b[8] + m[8]*b[9]
   d[9]=m[3]*b[7] + m[6]*b[8] + m[9]*b[9]
end

-- create mode_view matrix from camrea and model transf.
#define ICM(m,b) \
	Xx=m[1]*b[X] + m[2]*b[Y] + m[3]*b[Z] \
	Xy=m[4]*b[X] + m[5]*b[Y] + m[6]*b[Z] \
	Xz=m[7]*b[X] + m[8]*b[Y] + m[9]*b[Z] \
	Yx=m[1]*b[4] + m[2]*b[5] + m[3]*b[6] \
	Yy=m[4]*b[4] + m[5]*b[5] + m[6]*b[6] \
	Yz=m[7]*b[4] + m[8]*b[5] + m[9]*b[6] \
	Zx=m[1]*b[7] + m[2]*b[8] + m[3]*b[9] \
	Zy=m[4]*b[7] + m[5]*b[8] + m[6]*b[9] \
	Zz=m[7]*b[7] + m[8]*b[8] + m[9]*b[9] \
	local cx_ = b[10]-m[10] \
	local cy_ = b[11]-m[11] \
	local cz_ = b[12]-m[12] \
	Tx = m[1]*cx_ + m[2]*cy_ + m[3]*cz_ \
	Ty = m[4]*cx_ + m[5]*cy_ + m[6]*cz_ \
	Tz = m[7]*cx_ + m[8]*cy_ + m[9]*cz_


-- transpose(CM)*B  -- store in local X,Y,Z
#define named_ICM(n,m,b) \
local n##Xx=m[1]*b[X] + m[2]*b[Y] + m[3]*b[Z] \
local n##Xy=m[4]*b[X] + m[5]*b[Y] + m[6]*b[Z] \
local n##Xz=m[7]*b[X] + m[8]*b[Y] + m[9]*b[Z] \
local n##Yx=m[1]*b[4] + m[2]*b[5] + m[3]*b[6] \
local n##Yy=m[4]*b[4] + m[5]*b[5] + m[6]*b[6] \
local n##Yz=m[7]*b[4] + m[8]*b[5] + m[9]*b[6] \
local n##Zx=m[1]*b[7] + m[2]*b[8] + m[3]*b[9] \
local n##Zy=m[4]*b[7] + m[5]*b[8] + m[6]*b[9] \
local n##Zz=m[7]*b[7] + m[8]*b[8] + m[9]*b[9] \
	local cx_ = b[10]-m[10] \
	local cy_ = b[11]-m[11] \
	local cz_ = b[12]-m[12] \
local n##Tx = m[1]*cx_ + m[2]*cy_ + m[3]*cz_ \
local n##Ty = m[4]*cx_ + m[5]*cy_ + m[6]*cz_ \
local n##Tz = m[7]*cx_ + m[8]*cy_ + m[9]*cz_


-- map mesh
--todo:store in map mem

--transform
function trans(d,v)
   d[X]= Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx 
   d[Y]= Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty
   d[Z]= Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz
end

/*--rotat transpose
function rpose(d,m,x,y,z)
   d[X]= m[XX]*x + m[XY]*y + m[XZ]*z
   d[Y]= m[YX]*x + m[YY]*y + m[YZ]*z
   d[Z]= m[ZX]*x + m[ZY]*y + m[ZZ]*z
end*/

-- NOT INTEDNED FOR REAL TIME!!
-- NOT INTEDNED FOR REAL TIME!!
-- NOT INTEDNED FOR REAL TIME!!
function vsub( d,i, a,j, b,k )
   for q=0,2 do d[i+q] = a[j+q]-b[k+q] end
--   d[i+0],d[i+1],d[i+2] = a[j+0]-b[k+0],a[j+1]-b[k+1],a[j+2]-b[k+2]
end

function vadd( d,i, a,j, b,k )
   for q = 0, 2 do
	  d[i+q] = a[j+q]+b[k+q]
   end
end

function vcross(d,i,a,j,b,k)
--   d[i+0] = a[j+1]*b[k+2]-a[j+2]*b[k+1];
--   d[i+1] = a[j+2]*b[k+0]-a[j+0]*b[k+2];
--   d[i+2] = a[j+0]*b[k+1]-a[j+1]*b[k+0];
   for q=0,2 do d[i+q]=a[j+(q+1)%3]*b[k+(q+2)%3]-a[j+(q+2)%3]*b[k+(q+1)%3]end 
end
function vmulf(d,i,f) 
   for q=0,2 do d[i+q]=d[i+q]*f end
--   d[i+1]=d[i+1]*f
--   d[i+2]=d[i+2]*f
 end

function vdot(a,i,b,j) return a[i]*b[j] + a[i+1]*b[j+1] + a[i+2]*b[j+2] end
--#define vlen(a,i) (sqrt(vdot((a),(i),(a),(i))))
function vlen(a,i) return sqrt(vdot(a,i,a,i)) end
function vnorm(a,i) vmulf( a, i, 1./vlen(a,i) ) end

--NCPY
function ncpy(d,i,a,j,n) for q=0,n-1 do d[i+q]=a[j+q] end end


--SET MATRIX FPS MODE TMP
function MAT3_FPS(cm, p,y )
   local ps,pc,ys,yc = sin(p),cos(p),sin(y),cos(y)
--   local roll={ rc, rs,0, -rs, rc,0, 0,0,1. };
   local XM={ 1.,0,0, 0, pc, ps, 0, -ps, pc };
   local ZM={  yc, ys,0,	 -ys, yc,0,  0,0,1.  };
--   float m[9] ;
--   mat3_mul(m,XM,RM);
   --multipleh
   MAT3_MUL(cm,ZM,XM);
end







function deepcopy(orig) -- credits: MonstersGoBoom
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end 
