--span.lua
--
local flat = function(iy,x0,x1,color)
	local i,e = max(0,flr( x0+.5 )), min( RW, flr( x1-.5 ) )
	for ix=i,e,2 do pix(ix,iy,color ) end
end

-- DITHER
#define DO_DITH 0
#if DO_DITH 

#define S 3
--(3+LSH)
local DM={}
DM[0],DM[1],DM[2],DM[3] = 0<<S, 8<<S, 2<<S, 10<<S
DM[4],DM[5],DM[6],DM[7] = 12<<S, 4<<S, 14<<S, 6<<S
DM[8],DM[9],DM[10],DM[11] = 3<<S, 11<<S, 1<<S, 9<<S
DM[12],DM[13],DM[14],DM[15] = 15<<S, 7<<S, 13<<S, 5<<S
#undef S
#endif

#define sample(u,v) tex[ ((v>>LSH&TYA)<<TXSH)+(u>>LSH&TXA) ]

-- -- -- SPAN FUNC -- -- --

-- #define spinline(iy,x0,u0,v0,l0,x1,u1,v1,l1)


local span=function(iy, x0,u0,v0,l0, x1,u1,v1,l1 )
--   if x1<x0 then return end  
   --clamp screen
--   local i = flr( x0+.5 ) i=i<0 and 0 or i
   --   local e = flr( x1-.5 ) i=i>RW and RW or i
   local i = max(0,flr( x0+.5 ))
   local e = min(flr( x1-.5 ),RW)


   --both on same side of first PIXel center 
   if e < i then return end
   
   local es = i+.5-x0 -- distance from edge0 to PIX0 center
   local rd = L1/(x1-x0)

   #define XF(u) \
   local u##a = (u##1-u##0)*rd \
   local u##s = flr( u##0*L1 + u##a*es ) \
   u##a = flr( u##a )

   XF(u)   XF(v)   XF(l)
   
#if DO_DITH == 0 /* NO DITHERING */
   --   local dmy = 1+((iy&3)<<2)
   for ix=i,e do
	  --	local col =  sample( us, vs );
	  --	if col > 0 then pix(ix,iy,col) end
	  --	if col > 0 then 
	  local lum = ls >> LSH
	  if lum > 128 then
		 local col = sample( us, vs )
		 if col > 7 then -- bright or mid
			pix(ix,iy, col  >> (lum > 192 and 0 or 1) ) 
		 elseif col > 0 then -- dither mid - 1
			pix(ix,iy, ((lum>192) and col or 1) ) 
		 end
	  else --if lum > 64 then--if lum <= 256 then
		 pix(ix,iy,lum>64 and 1 or 0 )
	  end

#else /* USE DITHERING */
   
   for ix=i,e do
	  -- SENPAI: this dither and lighting can probably be made in a lot 
	  -- cleverer way, but I dont have time to dwell. LDJAM.
	  -- pix(ix,iy, sample( us, vs ))

	local d = DM[((iy&3)<<2)+(ix&3)]
	local lum = ls >> LSH
	if lum < 128 then -- dither 0 to 1
	   --if lum + d >> 7 > 0 then pix(ix,iy, lum + d >> 7  ) end
	   pix(ix,iy, lum + d >> 7 )
	else --if lum <= 256 then 
	   local col = sample( us, vs )
	   if col > 7 then -- dither bright - mid
		  local sh = ((lum&127) + d >> 7)>0 and 1 or 0
		  pix(ix,iy, col>>1-sh ) 
	   elseif col > 0 then -- dither mid - 1
--		  local sh = ((lum&127) + d >> 7)>0 and 0 or 2
--		  pix(ix,iy, col>>sh ) 
--		  local sh = 
		  pix(ix,iy, ((lum&127) + d >> 7)>0 and col or col>>2 ) 
	   end
	end

#endif


/*	  
	  local col = sample( us, vs )
	  if col > 7 then 
		 if ls > (1<<LSH-7) then
			pix( ix,iy, col - 8 )
		 else
			local lum =  ls - (1<<LSH-1)
			local d = DM[((iy&3)<<2)+(ix&3)]<<LSH-7
		 end
	  else
	  end
local col = sample( us, vs )
	  if col > 7 then
		 
		 local lum = ls >> LSH - 8
--		 local d = DM[1+(iy&3)+(ix&3)]
		 if lum > 127 then
			pix(ix,iy,col )
		 elseif lum > 63 then
			pix(ix,iy,col>>1 )
		 else
			pix(ix,iy,col>>2+1)
		 end
	  else
		 pix(ix,iy,col)
	  end
*/
/*
	  local lum = ls >> LSH - 2 
	  if lum < (1<<LSH-1) then
		 pix(ix,iy,1)
	  else 
		 local col = sample( us, vs )
		 if col > 7 then 

			local d = DM[1+(iy&3)+(ix&3)]
			lum = ls + d 
		 else
			pix(ix,iy,col);
		 end
	  end
*/	  
   --end
	  us,vs,ls=us+ua,vs+va,ls+la
   end
end




