dset ^basic.grd.i3e
*options little_endian
undef -9.99E+33
title EXP1
xdef  64 linear  0.0  5.625
ydef  40 GAUSR15 1
zdef  10 levels 1 2 3 4 5 6 7 8 9 10
tdef 99 linear  jan50     1mon
vars  7
lnp    1 99 eof
div   10 99 eof
vor   10 99 eof
moi   10 99 moisture
tmp   10 99 virture temp
tsfc   1 99 eof
topo   1 99 eof
endvars
