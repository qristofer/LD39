-- title: LD39
-- author: Nopykon || qristofer
-- desc: My attempt for Ludum Dare 39 (probably only a 3D-demo)
-- script: lua


#define RW 240
#define RH 136
#define RWH 120
#define RHH 68
#define ONE_TICK (1/60)
#define USE_CART 0

-- buttons
#define K_UP 0
#define K_DOWN 1
#define K_LEFT 2
#define K_RIGHT 3
#define K_Z 4
#define K_X 5


#include "macro.lua"

#define RATIO (240/136)
#define PI 3.1415926535897932384626433832795

local frame, last_time, fps, last_frame = 0, 0.,0.,0.
local tick, tick_last = 0,0.

#define CAM_FPS 0
#define CAM_ISO 1
local ZOOM,NEAR,FAR,CULL,FOG=2.0,-.1,100.,1.,0.
local ID = {1.,0.,0., 0.,1.,0., 0.,0.,1., 0.,0.,0.}	  
local CM={1.,0.,0., 0.,0.,1., 0.,-1.,0., 0.,-1024.,256.}
local CP,CV,CA,CW,C_mode={ 1000, -100,1000},{0,0,0},{PI/2,0,0},{0,0,0},CAM_ISO



local PP,PV,PVL,PD,PU={800,800,150},{0,0,10},{0,0,0},{0,1,0},{0,0,1}
local stepcounter, STEPBOUNCE = 0,0



#include "data.lua"
#include "raz.lua"

#define ibtn(x) (btn((x)) and 1 or 0 )
#define ibtnp(x) (btnp((x)) and 1 or 0 ) 

#include "render.lua"


--UPDATE
function update()


   local ax = ibtn(K_RIGHT)-ibtn(K_LEFT)
   local ay = ibtn(K_UP)-ibtn(K_DOWN)
   local az = ibtn(K_Z)-ibtn(K_X)


   --CAMERA
   if C_mode == CAM_FPS then
	  --first person cam
	  #define ACC 1
	  #define RACC .00125
	  if btn( K_Z ) then --strafe
		 for i=0,2 do CV[X+i]=CV[X+i]+CM[XX+i]*ax*ACC end
	  else  --rotate Z
		 CW[Z] = CW[Z]+ax*-RACC
	  end
	  --   if not ay == 0 then
	  if btn( K_X ) then
		 CW[X] = CW[X] + ay*RACC
	  else--walk forth
		 for i=0,2 do CV[X+i]=CV[X+i]-CM[ZX+i]*ay*ACC end
	  end
	  for i=0,2 do
		 --cancel av
		 CW[X+i]=CW[X+i]*.9
		 --cam friction
		 CV[X+i]=CV[X+i]*.97 
		 CP[X+i]=CP[X+i]+CV[X+i] 
		 CM[TX+i]=CP[X+i]
		 CA[X+i] = CA[X+i]+CW[X+i]
	  end

   elseif C_mode == CAM_ISO then

	  --DO MOUSE CONTROL AT ONCE!
	  --control character
	  #define PACC .35
	  #define PFRIC .93




	  --jump kinda
	  local ix,iy = flr(PP[X]/256), flr(PP[Y]/256)
	  local ground = ix>=0 and ix<MAP_W and iy>=0 and
		 iy<MAP_H and map[(iy*8)+ix+1]>0

	  local grounded = ground and PP[Z]==128

	  --collision
	  if ground and PP[Z] <= 128 and PP[Z] > 64 and PV[Z] <= 0 then
		 PV[Z]=0 
		 PP[Z]=128 
		 grounded = 1
			---PV[Z]*.05
	  end

	  if grounded then
		 if PP[Z] == 128 and tick - jumpeth < 3 then
			jumpeth = 0
			--PV[Z]= PV[Z] + 4
		 end
	  else
		 --gravity
		 #define GRAVITY .5
		 PV[Z] = PV[Z]-GRAVITY

	  end
		 
--	  PV[Z] = PV[Z]+PACC*az

	  --nlerps
	  #define NLERP_DIR .13
	  #define NLERP_UP .3
	  #define RECOVER_UP .5

	  -- nlerp player up
	  local ux = PU[X] + (PV[X]-PVL[X])*.1
	  local uy = PU[Y] + (PV[Y]-PVL[Y])*.1
	  PVL[X],PVL[Y]=PV[X],PV[Y]
	  local uz = PU[Z] + .05
	  local ul = 1./sqrt(ux*ux+uy*uy+uz*uz)
	  PU[X],PU[Y],PU[Z]=ux*ul,uy*ul,uz*ul

	  -- nlerp player dir
	  if not (ax==0 and ay==0) then --else
		 if not (ax==0 or ay==0) then ax,ay = ax*.71, ay*.71 end
		 --if PV[X]*PD[X] + PV[Y]*PD[Y] < 0 then PD[X],PD[Y]=PV[X],PV[Y] end
		 PV[X] = PV[X] + PACC*ax
		 PV[Y] = PV[Y] + PACC*ay
		 local dx,dy = PD[X]+ax*NLERP_DIR,PD[Y]+ay*NLERP_DIR

		 local len = sqrt(dx*dx+dy*dy)
		 if len > 0 then PD[X],PD[Y]=dx/len,dy/len else PD[X],PD[Y]=0,1 end

		 stepcounter = stepcounter + .24
	  end
	  
	  
	  --apply
	  for i=0,2 do
		 PV[X+i]=PV[X+i]*PFRIC
		 PP[X+i]=PP[X+i]+PV[X+i]
	  end

	  -- mdir, lookat, campos
	  local tx,ty,tz = PP[X]+0,PP[Y]-500,PP[Z]+350

	  CP[X]=CP[X]+(tx-CP[X])*.1
	  CP[Y]=CP[Y]+(ty-CP[Y])*.1
	  CP[Z]=CP[Z]+(tz-CP[Z])*.1

	  --cam 
	  Zx,Zy,Zz = CP[X]-PP[X], CP[Y]-PP[Y], CP[Z]-(PP[Z]+128)
	  local rl = sqrt( Zx*Zx + Zy*Zy + Zz*Zz )
	  --FOG = max(0.,min(1.,(rl-2)*.05))
	  --ZOOM = min(16.,.5 + rl*.025)
	  if rl > .001 then
		 Zx,Zy,Zz = Zx/rl,Zy/rl,Zz/rl
		 Xx,Xy,Xz = -Zy,Zx,0
		 rl = sqrt( Xx*Xx + Xy*Xy )
		 if rl > .001 then
			Xx,Xy = Xx/rl,Xy/rl
			CM[1],CM[2],CM[3] = Xx,Xy,Xz		   
			CM[7],CM[8],CM[9] = Zx,Zy,Zz		   
			CM[4] = Zy*Xz - Zz*Xy
			CM[5] = Zz*Xx - Zx*Xz
			CM[6] = Zx*Xy - Zy*Xx
		 end
		 CM[TX],CM[TY],CM[TZ]=CP[X],CP[Y],CP[Z]
	  end	
   end
end


function TIC()


   --UPDATE
   local t = time()/1e3
   local p,num,r = t - tick_last,0,0
   num = flr( p / ONE_TICK )
   r = p - num*ONE_TICK --(in seconds!))
   if num > 0 then
	  tick_last = t - r
	  num = min(10,num)
	  for i=0, num-1 do
		 update()
		 tick = tick + 1
	  end
   end


   render()

   --PRINT FPS
   --sample framerate every 60
   t = time()/1e3
   if frame-last_frame == 60 then
	  fps = 60/( t - last_time )
	  fps = flr( fps*100)/100
	  last_time = t
	  last_frame = frame
   end
   --print(fps, 2,2,15 )
   frame=frame+1 ;    
   
end
