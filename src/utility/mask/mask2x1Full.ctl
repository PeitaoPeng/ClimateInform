dset ^mask2x1Full.gr
undef -999.0
title mask of 2x1 grid for 60S-60N (mask2x1.sh)
ydef 139 linear -74.000000 1
xdef 180 linear 1.000000 2.000000
zdef 01 linear 1 1
tdef 1 Linear jan2002 1mo
vars 1
mask 0 99   [ land: -999.0; ocean: 1.0 ]
endvars
