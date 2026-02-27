DSET ^bmout.trop_adiv.cmap.gr
UNDEF   -999.0
TITLE eof    
*
XDEF 64 LINEAR  0.0  5.625
*
YDEF 40 GAUSR15 1        
*
ZDEF 1 LEVELS 1 
*
TDEF 30 LINEAR  JAN1992 1MO
*
VARS 28
ctran  0  99  clim trans
vlpc   0  99  clim vlp
vlpa   0  99 anom vlp
adiv   0  99 anom div
tran   0  99 transient frc
sfm    0  99 model simulated stream function
urm    0  99 model simulated rotational u
vrm    0  99 model simulated rotational v
sfo    0  99 verified stream function
uro    0  99 verified rotational u
vro    0  99 verified rotational v
xflxm  0  99 model simulated wvflx-x
yflxm  0  99 model simulated wvflx-y
xflxo  0  99 verified wvflx-x
yflxo  0  99 verified wvflx-y
sfc    0  99 clim stream function
udc    0  99 clim div u
vdc    0  99 clim div v
uda    0  99 anom div u
vda    0  99 anom div v
urc    0  99 clim rot u
vrc    0  99 clim rot v
absvor 0  99 absolute vort
wvsc1  0  99 stretching frc
sfm1   0  99 response to stretching frc
wvsc2  0  99 advection frc
sfm2   0  99 response to advection frc
totend 0  99 tensency due to totfrc
ENDVARS
