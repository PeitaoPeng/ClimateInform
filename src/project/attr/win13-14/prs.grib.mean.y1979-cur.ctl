dset ^prs.grib.mean.y%y4
options template big_endian
dtype grib
format yrev
index ^prs.grib.mean.y1979-cur.idx
undef -9.99E+33
title NCEP/NCAR ReANL PROJECT: CDAS: Monthly Means and Anom(using 79-95 clim)
xdef   144 linear    0.000  2.500
ydef    73 linear  -90.000  2.500
zdef    17 levels 
    1000     925     850     700     600     500     400     300     250     200
     150     100      70      50      30      20      10
tdef 420 linear     JAN1979     1mo
*
* plot:wind vectors:17:wind barbs
* display:wind vectors:d skip(UGRD,2);VGRD
*
* plot:wind anom:17:wind anomalies (79-95) (m/s)
* init:wind anom:open prs.grib.mean.clim.y1979-1995.ctl
* init:wind anom:set t 1 12
* init:wind anom:define uclim=UGRD.2
* init:wind anom:modify uclim seasonal
* init:wind anom:define vclim=VGRD.2
* init:wind anom:modify vclim seasonal
* display:wind anom:set gxout shaded
* display:wind anom:d mag(UGRD-uclim,VGRD-vclim)
* display:wind anom:run cbarb.gs
* display:wind anom:d skip(UGRD-uclim,2);VGRD-vclim
*
* function:isotach:17:mag(UGRD,VGRD):isotach (m/s)
*
* function:HGT anom:17:HGT-HGTclim:geopotential height anomaly (79-95) (gpm)
* init:HGT anom:open prs.grib.mean.clim.y1979-1995.ctl
* init:HGT anom:set t 1 12
* init:HGT anom:define HGTclim=HGT.2
* init:HGT anom:modify HGTclim seasonal
*
* function:TMP anom:17:TMP-TMPclim:temperature anomaly (79-95) (degK)
* init:TMP anom:open prs.grib.mean.clim.y1979-1995.ctl
* init:TMP anom:set t 1 12
* init:TMP anom:define TMPclim=TMP.2
* init:TMP anom:modify TMPclim seasonal
*
* function:STRM anom:17:STRM-STRMclim:stream function anomaly (79-95) (m**2/s)
* init:STRM anom:open prs.grib.mean.clim.y1979-1995.ctl
* init:STRM anom:set t 1 12
* init:STRM anom:define STRMclim=STRM.2
* init:STRM anom:modify STRMclim seasonal
*
* function:VPOT anom:17:VPOT-VPOTclim:velocity potential anomaly (79-95) (m**2/s)
* init:VPOT anom:open prs.grib.mean.clim.y1979-1995.ctl
* init:VPOT anom:set t 1 12
* init:VPOT anom:define VPOTclim=VPOT.2
* init:VPOT anom:modify VPOTclim seasonal
*
vars 21 
RELD      17 44,100,0 Relative divergence (/s)                                  
HGT       17 7,100,0 Geopotential height (gpm)                                  
RELV      17 43,100,0 Relative vorticity (/s)                                   
RH        17 52,100,0 Relative humidity (percent)                               
SPFH      17 51,100,0 Specific humidity (kg/kg)                                 
STRM      17 35,100,0 Stream function (m**2/s)                                  
TMP       17 11,100,0 Temperature (K)                                           
CBTW      17 194,100,0 Covariance between T and omega (K*Pa/s)                  
UGRD      17 33,100,0 u wind (m/s)                                              
CBUQ      17 192,100,0 Covariance between u and specific hum (m/s*gm/gm)        
CBTZW     17 197,100,0 Covariance between u and T (K*m/s)                       
CBMZW     17 196,100,0 Covariance between v and u (m**2/s**2)                   
CBUW      17 190,100,0 Covariance between u and omega (m/s*Pa/s)                
VGRD      17 34,100,0 v wind (m/s)                                              
CBVQ      17 193,100,0 Covariance between v and specific hum (m/s*gm/gm)        
CBTMW     17 198,100,0 Covariance between v and T (K*m/s)                       
CBVW      17 191,100,0 Covariance between v and omega (m/s*Pa/s)                
VPOT      17 36,100,0 Velocity potential (m**2/s)                               
VTMP      17 12,100,0 Virtual temperature (K)                                   
VVEL      17 39,100,0 Pressure vertical velocity (Pa/s)                         
CBQW      17 195,100,0 Covariance between spec. hum and omega (gm/gm*Pa/s)       
endvars
