DSET ^temp_forecast.above.djf.gr
*OPTIONS  little_endian
UNDEF  -9.99e+8
*
TITLE 2x2  Daily Tmean
*
XDEF 36 LINEAR -130 2
*
YDEF 19 LINEAR   20 2
*
ZDEF 1 LEVELS  1  1 
*
TDEF 999 LINEAR dec1995 1yr
*
VARS 1
t 1 00 daily Tmean
ENDVARS
