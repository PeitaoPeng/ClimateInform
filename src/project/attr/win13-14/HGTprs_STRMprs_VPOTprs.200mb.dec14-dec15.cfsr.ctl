dset ^HGTprs_STRMprs_VPOTprs.200mb.dec14-dec15.cfsr.gr
options little_endian
*format yrev
undef -9.99E+33
title NCEP/NCAR ReANL PROJECT: CDAS: Monthly Means and Anom(using 79-95 clim)
xdef   144 linear    0.000  2.500
ydef    73 linear  -90.000  2.500
zdef    1 levels 1 
tdef    99 linear     dec2014     1mo
*
vars 3 
hgt    0 99 ond z200                                  
strm   0 99 ond z200                                  
vpot   0 99 dec z200                                  
endvars
