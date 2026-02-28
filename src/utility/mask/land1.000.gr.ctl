dset ^land1.000.gr
options  big_endian
title land mask (land=1,ocean=0)
undef -999.0
xdef 360 linear    0.50 1.00
ydef 180  linear -89.50 1.00
zdef 1 linear 1 1
tdef 1 linear 01jan1963 1dy
vars 1
land   1  99 the land mask from GPCC land portion data file
ENDVARS
