dset ^land.mask.global.gri0.500m.lnx
options  little_endian
title land mask (land=1,ocean=0)
undef -999.0
xdef 720 linear    0.25 0.50
ydef 360  linear -89.75 0.50
zdef 1 linear 1 1
tdef 1 linear 01jan1963 1dy
vars 1
land     1  99 the land mask from GPCC land portion data file
ENDVARS
