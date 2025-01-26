DSET   /cpc/prcp/PRODUCTS/CMAP/pentad/current/cmap_pen.lnx
*
UNDEF  -999.0
*
options little_endian  365_day_calendar  
*
TITLE  Pentad CPC Merged Analysis of Precipitation (CMAP,Xie and Arkin 1997)
*
XDEF 144 LINEAR 1.25 2.5 
*
YDEF  72 LINEAR -88.75 2.5
*
ZDEF  02 LEVELS 1 2
*
TDEF 2628 LINEAR 01JAN1979 5dy
*
VARS 4       
cmap     1 99 merged analysis using all sources including ncep reanalysis (mm/day)
ecmap    1 99 error of cmap  (%)
cmapo    1 99 merged analysis using observation data only (mm/day)
ecmapo   1 99 error of cmapo (%)
ENDVARS
