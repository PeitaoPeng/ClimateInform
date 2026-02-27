yyyymm=200112
titmon='Dec 2001'
*
'open cahgt.ctl'
'open casst.ctl'
'open mask.ctl'
*
'set display color white'
'clear'
*
'run /nfsuser/g01/wx23ss/gscripts/rgbset.gs'
*
ts=1
te=18
*
tx=ts
while(tx<=te)
*
seas=getseas(tx)
lead=tx-4
*
'set strsiz 0.1'
'set string 4 tl 6'
'draw string 0.12 0.12 Huug van den Dool, CPC/NCEP/NWS/NOAA                    Base Period 1971-2000'
*
*grfile='casst_anom.'lead'.'yyyymm'.gr'
*say "grfile "grfile
*'enable print 'grfile
*
giffile='cahgt_anom.'lead'.'yyyymm'.gif'
say "giffile "giffile
*
'set t 'tx
#'define sstfull=maskout(sst.1,0.1-land.2(t=1))'
'define sstfull=sst.1'
*
'set grads off'
'set gxout shaded'
'set clevs -120 -100 -80 -60 -40 -20  0  20 40 60 80 100 120'
'set ccols 48  47 46   44   43  42 0 0 62 63  64 66 67 68'
#'set clevs 0  3  6  9 12 15 18 21 24 27 27.5 28 28.5 29 29.5 30 30.5 31'
#'set ccols 0 49 48 47 46 45 44 43 42 41   61 62   63 64   65 66   67 68 69'
'd sstfull'
'run /nfsuser/g01/wx23ss/gscripts/cbar.gs'
*
*'set gxout contour'
*'set ccolor 0'
*'set clevs 0  3  6  9 12 15 18 21 24 27 27.5 28 28.5 29 29.5 30 30.5 31'
*'set clab off'
*'d sstfull'
*
'set gxout contour'
'set ccolor 49'
#'set clevs 0  3  6  9 12 15 18 21 24'
'set clevs -120 -100 -80 -60 -40 -20  0'
'set clab off'
'd sstfull'
*
'set gxout contour'
'set ccolor 69'
#'set clevs 27 27.5 28 28.5 29 29.5 30 30.5 31'
'set clevs  20 40 60 80 100 120'
'set clab off'
'd sstfull'
*
'draw title 500 mb HGT based on SST CA Forecast : Lead 'lead' : 'seas' \ (last data used thru 'titmon' )'
'printim 'giffile' gif x712 y650'
*'print'
*'disable print'
*
say 'type in c to continue or quit to exit'
pull corquit
corquit
*
tx=tx+1
endwhile
function getseas(time)
if(time=1);seas='OND2001';endif;
if(time=2);seas='NDJ2001';endif;
if(time=3);seas='DJF2002';endif;
if(time=4);seas='JFM2002';endif;
if(time=5);seas='FMA2002';endif;
if(time=6);seas='MAM2002';endif;
if(time=7);seas='AMJ2002';endif;
if(time=8);seas='MJJ2002';endif;
if(time=9);seas='JJA2002';endif;
if(time=10);seas='JAS2002';endif;
if(time=11);seas='ASO2002';endif;
if(time=12);seas='SON2002';endif;
if(time=13);seas='OND2002';endif;
if(time=14);seas='NDJ2002';endif;
if(time=15);seas='DJF2003';endif;
if(time=16);seas='JFM2003';endif;
if(time=17);seas='FMA2003';endif;
if(time=18);seas='MAM2003';endif;
return seas
