dset ^land.mask.global.gri0.500p.lnx
options  little_endian
title land mask (land=1,ocean=0)
undef -999.0
xdef 721 linear  00.00 0.500
ydef 361 linear -90.00 0.500
zdef 1 linear 1 1
tdef 1 linear 01jan2007 1dy
vars 2
land      1  99 the original 0.50x0.50 grid land mask
land_ext  1  99 the extension of 8 grids 0.50x0.50 land mask
ENDVARS
