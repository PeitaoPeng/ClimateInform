dset ^land.mask.global.gri0.125p.lnx
options  little_endian
title land mask (land=1,ocean=0)
undef -999.0
xdef 2881 linear  00.00 0.125
ydef 1441  linear -90.00 0.125
zdef 1 linear 1 1
tdef 1 linear 01jan2007 1dy
vars 3
land       1  99 the original 0.25x0.25 grid land mask
land_ext   1  99 the extension of 8 grids 0.25x0.25 land mask
land_asia  1  99 the mask for analysis over the region of Asia
ENDVARS
