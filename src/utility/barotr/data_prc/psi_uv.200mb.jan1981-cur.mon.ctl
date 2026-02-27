dset ^psi_uv.200mb.jan1981-cur.mon.gr
options little_endian
undef -9.99E+33
title NCEP/NCAR ReANL PROJECT: CDAS: Monthly Means 
xdef   144 linear    0.000  2.500
ydef    73 linear  -90.000  2.500
zdef    1 levels 1 
tdef    9999 linear     jan1981  1mo
*
vars 3 
s   0 99 stmf at z200                                  
u   0 99 div  at z200                                  
v   0 99 div  at z200                                  
endvars
