-- vtx.lua
#define NX 4
#define NY 5
#define NZ 6

-- vertex space
TV={}
for i=0,512-1 do
   TV[i] = {0.,0.,0.,0.,0.,0.}--   x,y,z,u,v,L
end

#define EPS .001


-- un-indices and raz-call
function tv_indices(Iv_,polycount) --indices    --per poly 
   local tv,iv = TV,Iv_
--   local num, q = iv[1],1 
   local i=1
   for pli=1, polycount do --while num do

	  local num = iv[i] 

	  --flat, if simply flat, or 3 first verts are dark 
	  local count = num & 15	
	  local flat_color = num >> 4 --0 = texture	  
	  local A= tv[ iv[ i + 1 ] ]
	  local B= tv[ iv[ i + 2 ] ]
	  local C= tv[ iv[ i + 3 ] ]	  
	  local pA = (B[X]-A[X])*(C[Y]-A[Y])-(B[Y]-A[Y])*(C[X]-A[X])

	  if pA*CULL < -EPS and A[Z] > 0 then

		 for n=0,count-3 do
			--local A=tv[ iv[ i + n+0 ] ]
			B=tv[ iv[ (i+1) + n+1 ] ]
			C=tv[ iv[ (i+1) + n+2 ] ]
			if B[Z] > 0 and C[Z] > 0 then
			   raz( A, B, C, pA )
			end
		 end
	  end
	  i = i + count + 1 
   end
end

-- un-indices and raz-call
function tv_indices_unlit(Iv_,polycount,col) --indices    --per poly 
   local tv,iv,i = TV,Iv_,1
   for pli=1, polycount do --while num do
	  --flat, if simply flat, or 3 first verts are dark 
	  local count = iv[i] & 15	
	  local A,B,C= tv[ iv[ i + 1 ] ],tv[ iv[ i + 2 ] ],tv[ iv[ i + 3 ] ]	  
	  local pA = (B[X]-A[X])*(C[Y]-A[Y])-(B[Y]-A[Y])*(C[X]-A[X])
	  
	  if pA*CULL < -EPS and A[Z]>0 then
		 for n=0,count-3 do
			--local A=tv[ iv[ i + n+0 ] ]
			B=tv[ iv[ (i+1) + n+1 ] ]
			C=tv[ iv[ (i+1) + n+2 ] ]
			if B[Z] > 0 and C[Z] > 0 then
				  raz_flat( A,B,C,pA,col )
			end
		 end
	  end
	  i = i + count + 1 
   end
end





-- 
function mesh_draw( vv, vcount, Iv_, Polycount_, MM )
   local tv = TV
   --transform verts
   for i=1, vcount do
	  local v = vv[i]
	  local d = tv[i-1]
	  local z = Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz
	  
	  if z < 100 then
		 
		 local x = Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx
		 local y = Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty

		 --lighting
#if 0
--	local lum = max(0,v[NZ]<<1)
local dx,dy,dz = x-L0_x,y-L0_y,z-L0_z
local s2 = dx*dx + dy*dy + dz*dz
local sum = max(0,1 - s2/(512*1024))
local lum = flr(sum*255)


#else
   --#0
   local dx,dy,dz = x-L0_x,y-L0_y,z-L0_z
   local s2 = dx*dx + dy*dy + dz*dz ;
   local nx = (Xx*v[NX] + Yx*v[NY] + Zx*v[NZ]) 
   local ny = (Xy*v[NX] + Yy*v[NY] + Zy*v[NZ]) 
   local nz = (Xz*v[NX] + Yz*v[NY] + Zz*v[NZ]) 
   local lum = max(0,-(dx*nx+dy*ny+dz*nz))*(1./s2)*1024
/*   
   --#1
   dx,dy,dz = x-L1_x,y-L1_y,z-L1_z
   s2 = dx*dx + dy*dy + dz*dz ;
   lum = lum -(dx*nx+dy*ny+dz*nz)*(1./s2)*1024

   --#2
   dx,dy,dz = x-L2_x,y-L2_y,z-L2_z
   s2 = dx*dx + dy*dy + dz*dz ;
   lum = lum -(dx*nx+dy*ny+dz*nz)*(1./s2)*1024
*/
   
--		dx,dy,dz = x-L2_x,y-L2_y,z-L2_z
--		s2 = dx*dx + dy*dy + dz*dz ;
--		lum = lum + flr( 1024 / (1 + s2*.0001 ) )


		/*
		 local dx,dy,dz = x-L0_x,y-L0_y,z-L0_z
		 local s = sqrt(dx*dx + dy*dy + dz*dz)
		 local sum = max(0,1 - s/1024)

		 #if 0
		 local sr = 1./s
		 dx,dy,dz = dx*sr,dy*sr,dz*sr
		 local nx = (Xx*v[NX] + Yx*v[NY] + Zx*v[NZ]) * (1/128)
		 local ny = (Xy*v[NX] + Yy*v[NY] + Zy*v[NZ]) * (1/128)
		 local nz = (Xz*v[NX] + Yz*v[NY] + Zz*v[NZ]) * (1/128)
		 local dp = -(dx*nx+dy*ny+dz*nz)
		 local lum = max( 0, flr(sum*dp*255))
		 #else
		 local lum = max( 0, flr(sum*255))
		 #endif
*/
#endif

		 /*
		 dx,dy,dz = x-L1_x,y-L1_y,z-L1_z
		 sum = flr(dx*dx + dy*dy + dz*dz) >> 8
		 lum = lum + (L1_r<<8) / (1+sum )

		 dx,dy,dz = x-L2_x,y-L2_y,z-L2_z
		 sum = flr(dx*dx + dy*dy + dz*dz) >> 8
		 lum = lum + (L2_r<<8) / (1+sum )
		 */
		 d[6] = max(0,min(255, lum) )

		 

		 --zdiv	 (why here?)
		 z = max( .1, -z ) -- senpai, pushet forth
		 local fov = (RH*ZOOM)/z
		 d[X]=x*fov + RWH
		 d[Y]=y*-fov + RHH
		 d[Z] = z--RMEOVE UNUSED

		 -- uv set -- texcoords -- scale from 0-256 to TW,WH
		 #define NX 4
		 #define NY 5
		 #define NZ 6
		 #define VU 7
		 #define VV 8

		 d[4]=(v[VU]*TW)*(1/256.)
		 d[5]=(v[VV]*TH)*(1/128.)
		 /* --TMP HACK SHOULD BE /(1/256.) as well 
		 --(but then I would have to change the uv's which are mapped to 64x512)
		 */		 

	  else
		 d[Z] = -1000

	  end
   end

   tv_indices(Iv_,Polycount_)
end



function mesh_draw_unlit( vv, vcount, iv, polycount, color )
   local tv = TV
	--transform verts

	for i=1, vcount do
	   local v = vv[i]
	   local d = tv[i-1]
	   local z = Xz*v[X] + Yz*v[Y] + Zz*v[Z] + Tz
	   if z < -.1 then
		  local x = Xx*v[X] + Yx*v[Y] + Zx*v[Z] + Tx
		  local y = Xy*v[X] + Yy*v[Y] + Zy*v[Z] + Ty
		  --zdiv	
		  local fov = (RH*ZOOM) / (-z)
		  d[X]=x*fov + RWH
		  d[Y]=y*-fov + RHH
		  d[Z]=-z
	   else
		  d[Z] = 0.
	   end
	end
	tv_indices_unlit( iv, polycount,color )
end




--3D line
function line3(ax,ay,az,bx,by,bz,col)
   local z0 = Xz*ax + Yz*ay + Zz*az + Tz
   local z1 = Xz*bx + Yz*by + Zz*bz + Tz
   if z0 < -EPS and z1 < -EPS then
	  local x0 = Xx*ax + Yx*ay + Zx*az + Tx
	  local y0 = Xy*ax + Yy*ay + Zy*az + Ty
	  local x1 = Xx*bx + Yx*by + Zx*bz + Tx
	  local y1 = Xy*bx + Yy*by + Zy*bz + Ty
	  local fov0 = (RH*ZOOM)/z0
	  local fov1 = (RH*ZOOM)/z1
	  x0 = x0*-fov0 + RWH
	  y0 = y0*fov0 + RHH
	  x1 = x1*-fov1 + RWH
	  y1 = y1*fov1 + RHH
	  line(x0,y0,x1,y1,col)
   end
end

--3D point
function point3(ax,ay,az,col)
   local z0 = Xz*ax + Yz*ay + Zz*az + Tz
   if z0 < -EPS then
	  local x0 = Xx*ax + Yx*ay + Zx*az + Tx
	  local y0 = Xy*ax + Yy*ay + Zy*az + Ty
	  local fov0 = (RH*ZOOM)/z0
	  x0 = x0*-fov0 + RWH
	  y0 = y0*fov0 + RHH
	  rect(x0-1,y0-1,2,2,col)
   end
end
