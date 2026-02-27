dset ^land.mask.global.gri0.250m.lnx
options  little_endian
title land mask (land=1,ocean=0)
undef -999.0
xdef 1440 linear  0.125 0.25
ydef 720  linear -89.875 0.25
zdef 1 linear 1 1
tdef 1 linear 01jan1963 1dy
vars 1
land      1  99 the 0.25x0.25 grid land mask from 0.5x0.5 land portion
ENDVARS
