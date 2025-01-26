DSET ^landsea.mask.360x180.dat
title  OIv2sst
options sequential
UNDEF -9.99e+08
XDEF 360  linear 0.5 1
YDEF 180  linear -89.5 1
ZDEF 01 LEVELS 1
TDEF 1  linear Jan1979 1MON
VARS 1
land 0 99 land-sea mask (land: -100 ; sea : 100) 
ENDVARS
