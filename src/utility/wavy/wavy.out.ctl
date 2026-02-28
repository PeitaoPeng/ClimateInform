DSET   ^wavy.out
format yrev
*options sequential
UNDEF   -9.99e33
TITLE Z6M15 zasym HD=2e18     
*
XDEF 64 LINEAR  0.0  5.625
*
YDEF 40 GAUSR15 1
*
ZDEF  7 LEVELS 1000 850 700 500 300 200 100 
* simulated anom: s-s(t=2); observed anom: s(t=3)-s(t=2)
TDEF 3 LINEAR  JAN1992 1MO
*
VARS 19
sp     0    99     surf p
div    7   99     divergence
ze     7   99     vorticity
u      7   99     u
v      7   99     v
om     7   99     omega (derived)
s      7   99     stream fn
chi    7   99     velocity pot
tv     7   99     t
z      7   99     geopotential
slp    0    99     slp
ta     7   99     t
theta  7   99     potential t
tsa    0    99     anom tsfc    
fv     7   99     vorticity forcing
fd     7   99     divergence forcing
ft     7   99     temperature forcing
fg     7   99     geopotential forcing
fc     7   99     continuity   forcing
ENDVARS
