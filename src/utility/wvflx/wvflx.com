set lat 30 70
set lon 0 360
set z 6
set  mproj scaled
set gxout contour
d avs
*d hdivg(avu,avv)
set gxout vector
d avu2-avu;avv2-avv
draw title avg V, gh & div  200mb NDJ8788
print
set gxout contour
c
