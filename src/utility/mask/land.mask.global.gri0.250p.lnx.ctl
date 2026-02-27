dset ^land.mask.global.gri0.250p.lnx
options  little_endian
title land mask (land=1,ocean=0)
undef -999.
xdef 1441 linear  00.00 0.25
ydef 721  linear -90.00 0.25
zdef 1 linear 1 1
tdef 1 linear 01jan1963 1dy
vars 2
land      1  99 the original 0.25x0.25 grid land mask
land_ext  1  99 the extension of 6 grids 0.25x0.25 land mask
ENDVARS
