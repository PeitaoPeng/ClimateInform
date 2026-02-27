DSET /cpc/home/wd52px/BASE/mask/mask_land_sea_edge.lnx  
*
UNDEF  -999.0
*
TITLE  Land/Ocean Mask      
*
OPTIONS  little_endian 
*
XDEF 144 LINEAR 1.25 2.5 
*
YDEF  72 LINEAR -88.75 2.5
*
ZDEF  02 LEVELS 1 2
*
TDEF   1 LINEAR Oct2013 1mo
*
VARS 1       
mask  1  99  0=cean; 1=land; 2=partial land; 3=land board; 4=ocean board 
ENDVARS
