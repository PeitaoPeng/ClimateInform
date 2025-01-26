dset ^mask2x1.gr
undef -999.
title mask of 2x1 grid for 60S-60N (mask2x1.sh)
XDEF 180  LINEAR  1 2
YDEF 121 LINEAR  -60 1
zdef 01 levels 1
tdef 13 Linear jan2002 1mo
vars 1
mask 0 99   [ land: -999; ocean: 999 ]
endvars
