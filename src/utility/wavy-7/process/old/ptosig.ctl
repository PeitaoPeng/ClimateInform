DSET    /data/gcmprd/peng/obs/sghgrd.ec9293djf
UNDEF   -4095.0
TITLE R40 p to sig test data        
*
XDEF 128 LINEAR  0.0  2.8125
*
YDEF 102 GAUSR40 1            
*
ZDEF 18 LEVELS 0.995 0.981 0.960 0.920 0.856 0.777 0.688 0.594 0.497 0.425 0.375 0.325 0.275 0.225 0.175 0.124 0.074 0.021
TDEF 1 LINEAR  JAN1992 1MO
*
VARS 5
top     0    99     TOPOGRAPHY              
lnp     0    99     ln(Ps)                  
div     18   99     divg                 
vor     18   99     vorticity               
t       18   99     virtual temp            
ENDVARS
