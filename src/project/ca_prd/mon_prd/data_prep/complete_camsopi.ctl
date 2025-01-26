DSET  /export-8/cacsrv1/cpc/anal/cdas/bulletin/cams_opi_v0208/data/opi_merged.%y4%m2
options template  big_endian
*
UNDEF  -999.0
*
TITLE  CAMS + OPI output (2.5 deg grid)     
*
XDEF 144 LINEAR 1.25 2.5   
*
YDEF  72 LINEAR -88.75 2.5 
*
ZDEF 01 LEVELS 1 
*
TDEF 500 LINEAR jan1979 1mo
*
VARS 7        
cams  1 99  ch01     precipitation analysis based on CAMS 
camsn 1 99  ch01     number of CAMS gauges 
opi   1 99  ch01     OPI estimates  
comb  1 99  ch01     blended analysis with CAMS and OPI 
xxxx 1 99  ch01     blended analysis anomalies (7/87-6/95 climo: matches OPI)
comba 1 99 blended analysis anomalies (1979 - 1995 base period)
gam   1 99 anomalies expressed as % of gamma
ENDVARS
