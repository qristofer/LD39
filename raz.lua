-- raz.lua
#define U 4
#define V 5
#define L 6

-- lerp shift
#define LSH 15
#define L1 (1<<LSH)

#include "span.lua"

--#define SPAN span(iy,x0,u0,v0,0,x1,u1,v1,0)
--#define SPAN SNAP 

-- RAZ FUNC EDGE TRACER THINGY
function raz( a, b, c, pA )
   
   --sort y
   if a[Y]>b[Y] then local tmp=a a=b b=tmp pA=-pA end 
   if a[Y]>c[Y] then local tmp=a a=c c=tmp pA=-pA end
   if b[Y]>c[Y] then local tmp=b b=c c=tmp pA=-pA end

   local iy_b = max( 0, flr( a[Y] + .5 ) )
   local iy_e = min( RH-1, flr( c[Y] + .5 ) )
   --out y of bounds
   if iy_b >= iy_e then
	  return
   end
   local iy_m = max( 0, min( RH-1, flr( b[Y] + .5 ) ) )

   -- A -> C
   local ta = 1./(c[Y]-a[Y]) -- also r_ac
   local sy = iy_b + .5 -- first pixel center (not a[Y]!)
   local ts = (sy - a[Y])*ta
   local ac_xa,ac_xs = (c[X]-a[X])*ta, a[X]+(c[X]-a[X])*ts
   local ac_ua,ac_us = (c[U]-a[U])*ta, a[U]+(c[U]-a[U])*ts
   local ac_va,ac_vs = (c[V]-a[V])*ta, a[V]+(c[V]-a[V])*ts
   local ac_la,ac_ls = (c[L]-a[L])*ta, a[L]+(c[L]-a[L])*ts	

   -- A -> B
   ta = 1./(b[Y]-a[Y]) -- also r_ac
   ts = (sy - a[Y])*ta 
   local ab_xa,ab_xs = (b[X]-a[X])*ta, a[X]+(b[X]-a[X])*ts
   local ab_ua,ab_us = (b[U]-a[U])*ta, a[U]+(b[U]-a[U])*ts
   local ab_va,ab_vs = (b[V]-a[V])*ta, a[V]+(b[V]-a[V])*ts
   local ab_la,ab_ls = (b[L]-a[L])*ta, a[L]+(b[L]-a[L])*ts
   
   -- B -> C 
   ta = 1./(c[Y]-b[Y]) -- als r_bc
   ts = (iy_m+.5-b[Y])*ta
   local bc_xa, bc_xs = (c[X]-b[X])*ta, b[X]+(c[X]-b[X])*ts
   local bc_ua, bc_us = (c[U]-b[U])*ta, b[U]+(c[U]-b[U])*ts
   local bc_va, bc_vs = (c[V]-b[V])*ta, b[V]+(c[V]-b[V])*ts
   local bc_la, bc_ls = (c[L]-b[L])*ta, b[L]+(c[L]-b[L])*ts
   
   if pA > 0 then --001 then --c left
	  for iy=iy_b,iy_e-1 do
		 --
		 if iy < iy_m then -- A->B
			span( iy, ac_xs,ac_us,ac_vs,ac_ls,
				  ab_xs,ab_us,ab_vs,ab_ls ) 
			ab_xs,ab_us,ab_vs,ab_ls=
			   ab_xs+ab_xa,ab_us+ab_ua,ab_vs+ab_va,ab_ls+ab_la
		 else -- B->C
			span( iy,
				  ac_xs,ac_us,ac_vs,ac_ls,
				  bc_xs,bc_us,bc_vs,bc_ls
			) 
			bc_xs = bc_xs + bc_xa
			bc_us = bc_us + bc_ua
			bc_vs = bc_vs + bc_va
			bc_ls = bc_ls + bc_la			 
		 end
		 ac_xs = ac_xs + ac_xa
		 ac_us = ac_us + ac_ua
		 ac_vs = ac_vs + ac_va
		 ac_ls = ac_ls + ac_la
	  end
   else --if pA < -.001 then --c right
	  for iy=iy_b,iy_e-1 do
		 --
		 if iy < iy_m then
			span( iy,ab_xs,ab_us,ab_vs,ab_ls,
				  ac_xs,ac_us,ac_vs,ac_ls)
			ab_xs,ab_us,ab_vs,ab_ls=
			   ab_xs+ab_xa,ab_us+ab_ua,ab_vs+ab_va,ab_ls+ab_la
		 else
			span( iy,bc_xs,bc_us,bc_vs,bc_ls,
				  ac_xs,ac_us,ac_vs,ac_ls) 
			bc_xs,bc_us,bc_vs,bc_ls =
			   bc_xs+bc_xa,bc_us+bc_ua,bc_vs+bc_va,bc_ls+bc_la
		 end
		 ac_xs,ac_us,ac_vs,ac_ls =
			ac_xs+ac_xa,ac_us+ac_ua,ac_vs+ac_va,ac_ls+ac_la
	  end
   end
end


#undef SPAN

-- FLAT POLY RAZ FUNC EDGE TRACER THINGY
function raz_flat( a, b, c, pA, color  )

--	local pA = (b[X]-a[X])*(c[Y]-a[Y])-(b[Y]-a[Y])*(c[X]-a[X])
--   if pA*CULL > -0.001 then return end --back face cull

	--sort y
    if a[Y]>b[Y] then local tmp=a a=b b=tmp pA=-pA end 
	if a[Y]>c[Y] then local tmp=a a=c c=tmp pA=-pA end
	if b[Y]>c[Y] then local tmp=b b=c c=tmp pA=-pA end

	local iy_b = max( 0, flr( a[Y] + .5 ) )
	local iy_m = max( 0, min( RH-1, flr( b[Y] + .5 ) ) )
	local iy_e = min( RH-1, flr( c[Y] + .5 ) )
	local sy = iy_b + .5 -- first PIXel center (not a[Y]!)

	--out y of bounds
	if iy_b >= iy_e then return end

	--TODO: TURN FIXED POINT
	--REC, ADDERS 
	-- A -> C
   	local ac_ta = 1./(c[Y]-a[Y]) -- also r_ac
   	local ac_ts = (sy - a[Y])*ac_ta 
	local ac_xa = (c[X]-a[X])*ac_ta
	local ac_xs = a[X]+(c[X]-a[X])*ac_ts
	-- A -> B
   	local ab_ta = 1./(b[Y]-a[Y]) -- also r_ac
   	local ab_ts = (sy - a[Y])*ab_ta 
	local ab_xa = (b[X]-a[X])*ab_ta
	local ab_xs = a[X]+(b[X]-a[X])*ab_ts
	-- B -> C 
  	local bc_ta = 1./(c[Y]-b[Y]) -- als r_bc
	local bc_ts = (iy_m+.5-b[Y])*bc_ta
	local bc_xa = (c[X]-b[X])*bc_ta
	local bc_xs = b[X]+(c[X]-b[X])*bc_ts

#if HALF_MODE

#define SPAN flat(iy,x0,x1,color)

#else

--#define SPAN flat(iy,x0,x1,color)
#define SPAN \
	local i = max(0,flr(x0+.5 )) \
	local e = max( 0, min( RW, flr( x1-.5 ) ) ) \
	for _ix=i,e do pix(_ix,iy,color ) end


#endif
	
	if pA > 0 then --001 then --c left
	   for iy=iy_b,iy_e-1 do
		  local x0 = ac_xs ac_xs = ac_xs + ac_xa
		  --
		  if iy < iy_m then -- A->B
			 local x1 = ab_xs
			 ab_xs = ab_xs + ab_xa
			 SPAN
		  else -- B->C
			 local x1 = bc_xs 
			 bc_xs = bc_xs + bc_xa
			 SPAN
		  end
	   end
	else --if pA < -.001 then --c right
	   for iy=iy_b,iy_e-1 do
		  local x1 = ac_xs 
		  ac_xs = ac_xs + ac_xa
		  --
		  if iy < iy_m then
			 local x0 = ab_xs 
			 ab_xs = ab_xs + ab_xa
			 SPAN
		  else
			 local x0 = bc_xs 
			 bc_xs = bc_xs + bc_xa
			 SPAN
		  end
	   end
	end
end

#undef SPAN
#undef U
#undef V
#undef L

