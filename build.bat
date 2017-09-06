


::pek img/tex.png tex
::RAD 3d/char0.dae 3d/char0.lua char0 0
::RAD 3d/char1.dae 3d/char1.lua char1 0
::RAD 3d/char2.dae 3d/char2.lua char2 0



::RAD 3d/grass_flat.dae 3d/grass.lua grass 0
::RAD 3d/hex.dae 3d/hex.lua hex 0
::RAD 3d/hex2.dae 3d/hex2.lua hex2 0


::RAD 3d/box.dae 3d/box.lua box 0
::RAD 3d/grass.dae 3d/grass.lua grass 0
::RAD 3d/road.dae 3d/road.lua road 0
::@ wc -c 3d/ico.lua	

:: > --- you coulan use this part 


::gcc -x c -std=c90 main.lua -E | grep -v #^
::	  | grep -v -e "^[[:space:]]*$"^
::	  | sed -r "/^(\s*--|$)/d;"^
::	  > tmp/tmp.lua

gcc -x c -std=c90 main.lua -E | grep -v #^
	  | grep -v -e "^[[:space:]]*$"^
	  | sed -r "/^(\s*--|$)/d;"^
	  > tmp/tmp.lua

	  

tic -code tmp/tmp.lua