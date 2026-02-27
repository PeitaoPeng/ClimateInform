dset /cpc/prcp/PRODUCTS/CPC_UNI_PRCP/GAUGE_GLB/%y4/PRCP_CU_GAUGE_V1.0GLB_0.50deg.lnx.%y4%m2%d2.RT
* 
options  little_endian template
*
title global daily analysis (real time, from 2007)  
undef -99.0
xdef 720 linear  00.250 0.50
ydef 360  linear -89.75 0.50
zdef 1 linear 1 1
tdef 30000 linear 01jan2007 1dy
vars 2
rain     1  00 the grid analysis (0.1mm/day)
nstn     1  00 the number of gauge
ENDVARS
