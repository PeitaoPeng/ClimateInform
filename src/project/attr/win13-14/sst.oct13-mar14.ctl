DSET  ^sst.oct13-mar14.gr
options little_endian
*
UNDEF  -999000000
*
TITLE  CAMS + OPI output (2.5 deg grid)     
*
XDEF 360 LINEAR 0.5  1.0  
*
YDEF 180 LINEAR -89.5  1.0 
*
ZDEF 01 LEVELS 1 
*
TDEF 500 LINEAR oct2013 1mo
*
VARS 1        
sst  0 99  dec mean sst 
ENDVARS
