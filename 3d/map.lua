-- map.lua -- vertex-mode
map_min = {0,0,0}
map_max = {256,512,256}
map_polycount = 30
map_vcount = 99
map_icount = 150
map_verts = {
{128,0,0, 0,-127,0, 128,193},
{256,0,0, 0,-127,0, 256,193},
{256,0,128, 0,-127,0, 256,225},
{128,0,128, 0,-127,0, 128,225},
{0,128,256, 127,0,0, 128,225},
{0,0,256, 127,0,0, 0,225},
{0,0,128, 127,0,0, 0,194},
{0,128,128, 127,0,0, 128,194},
{0,0,0, 0,-127,0, 128,193},
{128,0,0, 0,-127,0, 256,193},
{128,0,128, 0,-127,0, 256,225},
{0,0,128, 0,-127,0, 128,225},
{128,0,128, 0,0,127, 128,193},
{256,0,128, 0,0,127, 128,224},
{256,128,128, 0,0,127, 0,225},
{128,128,128, 0,0,127, 0,193},
{256,0,0, 127,0,0, 128,193},
{256,128,0, 127,0,0, 256,193},
{256,128,128, 127,0,0, 256,225},
{256,0,128, 127,0,0, 128,225},
{0,0,128, 0,0,127, 128,225},
{128,0,128, 0,0,127, 0,225},
{128,128,128, 0,0,127, 0,194},
{0,128,128, 0,0,127, 128,194},
{256,256,0, 127,0,0, 128,193},
{256,384,0, 127,0,0, 256,193},
{256,384,128, 127,0,0, 256,225},
{256,256,128, 127,0,0, 128,225},
{256,384,0, 127,0,0, 128,193},
{256,512,0, 127,0,0, 256,193},
{256,512,128, 127,0,0, 256,225},
{256,384,128, 127,0,0, 128,225},
{256,256,0, 0,127,0, 124,58},
{128,256,0, 0,127,0, 252,58},
{128,256,128, 0,127,0, 252,91},
{256,256,128, 0,127,0, 124,91},
{256,128,0, 127,0,0, 128,193},
{256,256,0, 127,0,0, 256,193},
{256,256,128, 127,0,0, 256,225},
{256,128,128, 127,0,0, 128,225},
{128,256,0, 0,127,0, -4,58},
{0,256,0, 0,127,0, 124,58},
{0,256,128, 0,127,0, 124,91},
{128,256,128, 0,127,0, -4,91},
{0,256,128, 127,0,0, 128,194},
{0,256,256, 127,0,0, 128,225},
{0,128,256, 127,0,0, 0,225},
{0,128,128, 127,0,0, 0,194},
{128,128,128, 0,0,127, 128,225},
{256,256,128, 0,0,127, 0,193},
{128,256,128, 0,0,127, 128,193},
{0,128,128, 0,0,127, 128,193},
{128,256,128, 0,0,127, 0,225},
{0,256,128, 0,0,127, 0,193},
{128,256,128, 0,0,127, 128,97},
{256,256,128, 0,0,127, 256,97},
{256,384,128, 0,0,127, 256,129},
{128,384,128, 0,0,127, 128,129},
{256,512,128, 0,0,127, 256,161},
{128,512,128, 0,0,127, 128,161},
{0,384,128, 0,0,127, 0,129},
{0,512,128, 0,0,127, 0,161},
{0,256,128, 0,0,127, 0,97},
{0,384,128, 127,0,0, 128,97},
{0,512,128, 127,0,0, 0,97},
{0,512,150, 127,0,0, 0,92},
{0,384,150, 127,0,0, 128,92},
{0,256,128, 127,0,0, 256,97},
{0,256,150, 127,0,0, 256,92},
{128,384,128, 0,-127,0, 128,97},
{256,384,128, 0,-127,0, 0,97},
{256,384,150, 0,-127,0, 0,92},
{128,384,150, 0,-127,0, 128,92},
{0,384,128, 0,-127,0, 256,97},
{0,384,150, 0,-127,0, 256,92},
{128,512,128, 0,-127,0, 128,97},
{256,512,128, 0,-127,0, 0,97},
{256,512,150, 0,-127,0, 0,92},
{128,512,150, 0,-127,0, 128,92},
{0,512,128, 0,-127,0, 256,97},
{0,512,150, 0,-127,0, 256,92},
{128,256,128, 0,-127,0, 128,97},
{256,256,128, 0,-127,0, 0,97},
{256,256,150, 0,-127,0, 0,92},
{128,256,150, 0,-127,0, 128,92},
{0,256,128, 0,-127,0, 256,97},
{0,256,150, 0,-127,0, 256,92},
{128,384,128, 127,0,0, 128,97},
{128,512,128, 127,0,0, 0,97},
{128,512,150, 127,0,0, 0,92},
{128,384,150, 127,0,0, 128,92},
{128,256,128, 127,0,0, 256,97},
{128,256,150, 127,0,0, 256,92},
{256,384,128, 127,0,0, 128,97},
{256,512,128, 127,0,0, 0,97},
{256,512,150, 127,0,0, 0,92},
{256,384,150, 127,0,0, 128,92},
{256,256,128, 127,0,0, 256,97},
{256,256,150, 127,0,0, 256,92},
}
map_ind = {
4,79,75,78,80,
4,75,76,77,78,
4,93,94,95,96,
4,87,88,89,90,
4,63,64,65,66,
4,60,57,59,61,
4,57,56,58,59,
4,28,29,30,31,
4,73,69,72,74,
4,69,70,71,72,
4,97,93,96,98,
4,91,87,90,92,
4,67,63,66,68,
4,62,54,57,60,
4,54,55,56,57,
4,24,25,26,27,
4,85,81,84,86,
4,81,82,83,84,
4,40,41,42,43,
4,32,33,34,35,
4,51,48,52,53,
4,48,14,49,50,
4,44,45,46,47,
4,36,37,38,39,
4,20,21,22,23,
4,16,17,18,19,
4,12,13,14,15,
4,4,5,6,7,
4,8,9,10,11,
4,0,1,2,3,
}