DSET   /net/ptp/nmcgcm/frc.9192a.grads
UNDEF   -4095.0
TITLE R40 gcm sigma history data    
*
XDEF 64 LINEAR  0.0  5.625
*
YDEF 40 GAUSR15 1            
*
ZDEF 10 LEVELS 0.95 0.85 0.75 0.65 
0.55 0.45 0.35 0.25 0.15 0.05
*
TDEF 1 LINEAR  JAN1992 1MO
*
VARS 5
fv      10    99     div                     
fd      10    99     vorticity               
ft      10    99     virtual temp            
fc      10    99     continuity frc          
dh      10    99     dibatic heating         
ENDVARS
