DSET  ^mask1x1ForMOM3.gr
UNDEF  -999.0
TITLE   1x1 mask based on MOM3 grid for 60S-50N
* for masking out 1x1 SST from CFS model
XDEF 360  LINEAR  0.5 1.0
YDEF 180 LINEAR  -89.5 1.0
zdef 1 linear 1 1
TDEF 1 LINEAR JAN2002 1mo
VARS 1
msk 0   99  999 for ocean;  -999 for land
ENDVARS
