--render.lua
local light,light_count = {},3
light[0] = { 0,0,0} 
light[1] = { 0,400, 400} 
light[2] = { 1000,1000, 400} 
local L0_x,L0_y,L0_z,L0_r = 0,0,300, 256*512
local L1_x,L1_y,L1_z,L1_r = 0,400,300, 1024*1024
local L2_x,L2_y,L2_z,L2_r = 1000,1000,300,1024
function proc_lights()
   --todo: sort, find 3 most important lights
   --transform by view matrix
   local v = light[0]
   L0_x = Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx 
   L0_y = Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty
   L0_z = Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz

   v = light[1]
   L1_x = Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx 
   L1_y = Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty
   L1_z = Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz

   v = light[2]
   L2_x = Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx 
   L2_y = Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty
   L2_z = Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz
end

#include "vtx.lua"

#include "3d/char0.lua"
#include "3d/char1.lua"
#include "3d/char2.lua"


#define MSH(name) {v = name##_verts, vc = name##_vcount, pc = name##_polycount,\
				   iv=name##_ind}


char0 = MSH(char0)
char1 = MSH(char1)
char2 = MSH(char2)

char = deepcopy( char0 )

#include "3d/box.lua"
box = MSH(box)


--#include "3d/block0.lua"
--#include "3d/block1.lua"
--#include "3d/block2.lua"
#include "3d/grass.lua"
#include "3d/hex.lua"
#include "3d/hex2.lua"
--#include "3d/tree.lua"

--#include "3d/char_lookup.lua"
--#include "3d/char_bow.lua"
--#include "3d/char.lua"



tile={
--   MSH(block0),
--   MSH(block1),
   MSH(grass),
   MSH(hex),--bridge
   MSH(hex2),
   MSH(hex2),

--   MSH(hex),
--   MSH(hex2),
--   MSH(grass)
}
#define G 1
#define B 2
#define C 3
#define G 1
local map={
   G,G,G,G,G,C,C,C,
   G,G,G,C,C,C,C,C,
   G,G,C,C,C,C,C,C,
   G,G,C,C,C,C,B,C,

   B,0,B,B,B,0,B,0,
   B,0,B,0,B,0,B,B,
   B,0,B,0,B,0,0,0,
   B,B,B,G,B,0,0,0,

}
#undef A
#undef B
#undef C
#undef G


local jumpeth = 0

--RENDER
function render()

   if ibtnp( K_Z ) then jumpeth = tick end 

   -- VERTEX ANIMATE player
   do 
	  local d,a,b,t = char.v, char0.v, char1.v,0
	  local pv = min(1,vlen(PV,X))--, PV, X))
	  if pv > .1 then
		 t = sin(stepcounter)
		 STEPBOUNCE = t*pv*2
		 t = t*.5 + .5
	  else
--		 b = char2.v
--		 t = .5 + sin(tick*.025 )*.5
	  end

	  --TODO:playout before change.. .or doubly interpolate.
	  
	  local it = 1-t
--	  trace( char.vc ) 
	  for i = 1, char.vc do
		 for j = 1, 3 do d[i][j] = a[i][j]*it + b[i][j]*t	end
	  end
   end
   
   cls(0)
   local l = light[0]
   #define CLERP .052
   local lx = PP[X] + cos(tick*.01)*100--+ 40 + 
   local ly = PP[Y] + sin(tick*.01)*100 - 50 --sin(tick*.001)*100
   local lz = PP[Z] + 200

   l[X] = l[X]+(lx-l[X])*CLERP
   l[Y] = l[Y]+(ly-l[Y])*CLERP
   l[Z] = l[Z]+(lz-l[Z])*CLERP

--   light[1][X] = cos(tick*.1)*150
--   light[1][Y] = 500 + sin(tick*.01)*500
--   light[1][Z] = 256

   --   light[2][X]=1000 + cos(tick*.01)*500
--   light[2][Y]=1500 + sin(tick*.01)*500
--   light[2][Y]=light[1][X]+1000
   
   if C_mode == CAM_FPS then MAT3_FPS( CM, CA[X],CA[Z] ) end

   IC_ID()
   draw_stars()
   proc_lights()

   --poly
   if false then 
	  local t = tick *.01
	  local cx,cy,q = RWH, RHH, PI/2
	  local a={cx+cos(t+0*q)*100,cy+sin(t+0*q)*100,1, 0,0,.01}
	  local b={cx+cos(t+1*q)*100,cy+sin(t+1*q)*100,1, 100,0,1}
	  local c={cx+cos(t+2*q)*100,cy+sin(t+2*q)*100,1, 100,100,.01}
	  local d={cx+cos(t+2.5*q)*100,cy+sin(t+2.5*q)*100,1, 0,100,1}
	  raz(a,b,c,1)   raz(a,c,d,1)
   end




--   ICM(CM,MM)
--   mesh_draw( map_verts, map_vcount, map_ind, map_polycount, ID )


   --draw map

   #define MAP_W 8
   #define MAP_H 8
   local MM={1,0,0, 0,1,0, 0,0,1, 0,0,0}
   local xi = flr(PP[X]/256)
   local yi = flr(PP[Y]/256)
   local xi0 = min(MAP_W,max(1,xi-2))
   local yi0 = min((MAP_H-1),max(0,yi-1))
   local xi1 = max(1,min(MAP_W,xi+2))
   local yi1 = max(0,min((MAP_H-1),yi+3))

   for y = yi1, yi0,-1 do
	  for x = xi0, xi1 do
		 local t = map[(y<<3) + x ]
		 if t > 0 then
			MM[TY]=256*y
			MM[TX]=256*(x-1)
			ICM(CM,MM)
			t = tile[ t ]
			mesh_draw( t.v, t.vc, t.iv, t.pc, MM )
		 end

	  end
   end

   --player
   do--if x == xi and y == yi then
	  --player shadow
	  local dx,dy,dz = PD[X],PD[Y],PD[Z]--sin(tick*.01),cos(tick*.01)
	  local ux,uy,uz,rx,ry,rz,rl = PU[X],PU[Y],PU[Z]
	  rx=dy*uz - dz*uy
	  ry=dz*ux - dx*uz
	  rz=dx*uy - dy*ux
	  rl=1/sqrt(rx*rx+ry*ry+rz*rz)
	  rx,ry,rz = rx*rl,ry*rl,rz*rl
	  --recalc d (tilted)(which is really Y)
	  dx=uy*rz - uz*ry
	  dy=uz*rx - ux*rz
	  dz=ux*ry - uy*rx

	  local pm ={
		 rx*.5,ry*.5,rz*.5,
		 dx*.5,dy*.5,dz*.5,
		 ux*.5,uy*.5,uz*.5,
		 PP[X],PP[Y],PP[Z]+STEPBOUNCE
	  }
	  local l,lx,ly,lz,lr = light[0]
	  lx,ly,lz = l[X]-PP[X],l[Y]-PP[Y],l[Z]-PP[Z]
	  lr = 1./sqrt(lx*lx+ly*ly+lz*lz)
	  lx,ly,lz=lx*lr,ly*lr,lz*lr
	  
	  local SM={
		 rx*.6,ry*.6,0,
		 dx*.6,dy*.6,0,
			-lz*lx,-lz*ly,0, --normal to light ?
		 PP[X],--+lx*(PP[Z]-128),
		 PP[Y],--+ly*(PP[Z]-128),
		 128
	  };

	  IC_ID()
	  ICM(CM,SM)
	  --			mesh_draw_unlit( box.v, box.vc, box.iv, box.pc, 15 )
	  mesh_draw_unlit( char.v, char.vc, char.iv, char.pc, SM )

	  --player 
	  ICM(CM,pm)
	  mesh_draw( char.v, char.vc, char.iv, char.pc, pm )
	  --mesh_draw( box.v, box.vc, box.iv, box.pc, PM )
   end



   /*
   local xd,yd = CM[ZX], CM[ZY]
   if yd > 0 then --start ye
	  for y = 8, 1 do
		 if xd > 0 then --start ye
			for x = 8, 1 do
			end
		 else
			for x = 1, 8 do
			end
		 end
	  end
   else 
	  if xd > 0 then --start ye
		 for x = 8, 1 do
		 end
	  else
		 for x = 1, 8 do
		 end
	  end
   end


   local MM={1,0,0, 0,1,0, 0,0,1, 0,0,0}
   MM[TY]=MM[TY]+256
   ICM(CM,MM)
   mesh_draw( tile[2].v, tile[2].vc, tile[2].iv, tile[2].pc, ID )
   
   MM[TY]=MM[TY]+256
--   MM[TX]=MM[TX]+256
   ICM(CM,MM)
   mesh_draw( tile[3].v, tile[3].vc, tile[3].iv, tile[3].pc, ID )


   MM[TY]=MM[TY]+256
--   MM[TX]=MM[TX]+256
   ICM(CM,MM)
   mesh_draw( tile[4].v, tile[4].vc, tile[4].iv, tile[4].pc, ID )
*/
--   mesh_draw( map_verts, map_vcount, map_ind, map_polycount, ID )

   IC_ID()
   --   raz_flat(a,b,d,1,14)
   line3( 0,0,0, 100,0,0, 8 ) 
   line3( 0,0,0, 0,100,0, 9 ) 
   line3( 0,0,0, 0,0,100, 10 ) 


   -- player dir
   line3( PP[X],PP[Y],PP[Z],  
		  PP[X]+PD[X]*32,  PP[Y]+PD[Y]*32, PP[Z]+PD[Z]*32,12)

   line3( PP[X],PP[Y],PP[Z],  
		  PP[X]+PU[X]*32,  PP[Y]+PU[Y]*32, PP[Z]+PU[Z]*32,12)


   -- draw lights 
   for i=0,2 do point3( light[i][X],light[i][Y],light[i][Z],2) end


/*
   local ix, iy = flr(PP[X]/256), flr(PP[Y]/256)
   print( "x = " .. ix, 10,10,2)
   print( "y = " .. iy, 10,20,2)	     
   print( "s = " .. stepcounter, 10,30,2)	     */
--   print( "s = " .. vlen( PV,X), 10,30,2)	     
   
   --rayban()

end

/*#include "play.lua"*/

--STARS
function draw_stars()
   local seed,x,y,z,x0,y0,z0,fov = 1245,0,0,0, 0,0,0, 0
   for i=0,120 do
	  x,seed=(seed&255)-128,(seed<<2)+(seed>>1)
	  y,seed=(seed&255)-128,(seed<<2)+(seed>>1)
	  z,seed=(seed&255)>>1,(seed<<2)+(seed>>1)	  
	  z0 = Xz*x + Yz*y + Zz*z
	  if z0 < -0 then
		 fov = (RH*ZOOM)/z0
		 pix( flr((Xx*x+Yx*y+Zx*z)*-fov + RWH),
			  flr((Xy*x + Yy*y + Zy*z)*fov + RHH),
			  1+(z>>3))
	  end
   end
end
