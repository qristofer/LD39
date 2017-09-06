-- data.lua - ik ik data, generic term ik 


-- meshes
--
--
-- 
--#include "3d/ico.lua"
--for unpacking 
--#include "3d/ico.lua" /*-- THE ONLY MODEL wHERE w_vtx < w_P,w_N,w_UV..*/

--when is this used ? never.
#if 0
#include "3d/map.lua"
-- unpack mesh-map 
map_={}
map_pc=0

function proc_()
   local i,iv, num = 1, map_ind, map_ind[1]
--   for poli=0, map_PC-1 do
   while num do
	  i = i + 1 -- iv[i] = num, ++i
	  --trace(num)
	  -- new vertex array 
	  local va = {}
	  -- gather poly vertices 
	  for j=0,num-1 do
		 va[j] = {0,0,0, 0,0,0, 0,0}
		 ncpy( va[j],X, map_P,iv[i+0]*3+1, 3 )
		 ncpy( va[j],4, map_N,iv[i+1]*3+1, 3 )
		 ncpy( va[j],7, map_T,iv[i+2]*2+1, 2 )
		 --trace('vertex: '..va[j][X])
		 i = i + 3
	  end

	  num = iv[i] 
	  
	  --plane normal ( use a,b,c only )
	  local a,b,c,n,len={0,0,0},{0,0,0},{0,0,0},{0,0,0,0},0
	  vsub(a,X, va[1],X, va[0],X)
	  vsub(b,X, va[2],X, va[0],X)
	  vcross(n,X,a,X,b,X)
	  len = vlen(n,1)

	  #if DEBUG 
	  if len == 0. then
		 trace( 'BAD NORMAL IN POLY ' ..poli ..'LEN = ' ..len )
	  else
	  #endif

		 vmulf(n,1,1./len)
		 --trace( 'NORMALT? = '..n[X]..', '..n[Y]..', '..n[Z] )
		 map_[map_pc] = {{ n[X],n[Y],n[Z], -vdot(n,X,va[0],X)},	num,va }
		 map_pc = map_pc + 1
		 #if DEBUG
	  end
	  #endif
   end
end
proc_()
local map = map_

#endif

--for i=0, map_pc-1 do
--   trace("P[" .. i .."]=" .. map_[i][1][Z] )
--end

#define RAM_BORDER 0x3ff8
#define RAM_SPRITE 0x4000
#define RAM_MAP 0x8000
#define RAM_PALETTE 0x03FC0


--poke( RAM_BORDER , 15, 1 ) 

--
--texture and palette 
--


local tex={}

#if USE_CART == 0 
/*
--load from lua tables, store in rom  
--(not to be used, but to be saved to the cartridge)
*/

--texture.lua -> tex_
#include "tex.lua"
for i=0,TW*TH-1 do tex[i]=tonumber(string.sub(tex_data, i+1,i+1 ),16)end
--tex table to RAM
for i=0,(TW*TH)-2,2 do poke( RAM_MAP + (i>>1), tex[i] | tex[i+1]<<4)end

-- tex_palette.lua -> palette 
for i=0,15 do
   for j=0,2 do
	  c = tonumber( string.sub( NOPY16,i*6+1+j*2, i*6+1+1+j*2 ),16 )
	  --	  tpal[1+i*3+j]=c
	  --	  cpal[1+i*3+j]=c
	  --trace( c ) 
	  poke(RAM_PALETTE+i*3 + j, c )
   end
end

sync()


#else /* --LOAD FROM CART WARNING OBSOLETE CODE PROBABLY! */

-- TEXTURE
#define TW 64
#define TXA 63
#define TXSH 6
#define TH 256 
#define TYA 255
#define TYSH 8

--for i=0,(TW*TH)-1,2 do

--load texture from cart
for i=0,(TW*TH)-2,2 do
   c = peek( RAM_MAP + (i>>1) )
   tex[i+1] = c >> 4 
   tex[i+0] = c & 15 
end

--palette should already be loaded 




#endif /*-- LOAD CART*/













