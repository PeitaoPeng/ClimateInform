titmon='Oct 2016'
*
'open caprec.ctl'
'open mask.ctl'
*
'set display color white'
'clear'
*
'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'
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
'draw string 0.12 0.12 Huug van den Dool, CPC/NCEP/NWS/NOAA                    Base Period 1981-2010'
*
*grfile='casst_anom.'lead'.'yyyymm'.gr'
*say "grfile "grfile
*'enable print 'grfile
*
giffile='caprec_anom.'lead'.gif'
say "giffile "giffile
*
'set t 'tx
#'define sstfull=maskout(sst.1,0.1-land.2(t=1))'
'define sstfull=sst.1'
*
'set grads off'
'set gxout shaded'
'set clevs -5 -4 -3 -2 -1 -0.5 -0.25 0 0.25 0.5 1 2 3 4 5'
'set ccols 29   27  25  24  23  22 21 0 0 31 32 33 34  35 37 39'
#set ccols 48  47 46   44   43  42 41 0 0 61 62 63  64 66 67 68'
#'set clevs 0  3  6  9 12 15 18 21 24 27 27.5 28 28.5 29 29.5 30 30.5 31'
#'set ccols 0 49 48 47 46 45 44 43 42 41   61 62   63 64   65 66   67 68 69'
'd sstfull'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
*
'set gxout contour'
'set ccolor 29'
#'set clevs 0  3  6  9 12 15 18 21 24'
'set clevs -5 -4 -3 -2 -1 -.5 -.25'
'set clab off'
'd sstfull'
*
'set gxout contour'
'set ccolor 39'
#'set clevs 27 27.5 28 28.5 29 29.5 30 30.5 31'
'set clevs  0.25 0.5 1 2 3 4 5'
'set clab off'
'd sstfull'
*
'draw title PRECIP (mm/day) based on SST CA Forecast : Lead 'lead' :\ 'seas' (last data used thru 'titmon' )'
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
if(time=1);seas='ASO2016';endif;
if(time=2);seas='SON2016';endif;
if(time=3);seas='OND2016';endif;
if(time=4);seas='NDJ2016';endif;
if(time=5);seas='DJF2017';endif;
if(time=6);seas='JFM2017';endif;
if(time=7);seas='FMA2017';endif;
if(time=8);seas='MAM2017';endif;
if(time=9);seas='AMJ2017';endif;
if(time=10);seas='MJJ2017';endif;
if(time=11);seas='JJA2017';endif;
if(time=12);seas='JAS2017';endif;
if(time=13);seas='ASO2017';endif;
if(time=14);seas='SON2017';endif;
if(time=15);seas='OND2017';endif;
if(time=16);seas='NDJ2017';endif;
if(time=17);seas='DJF2018';endif;
if(time=18);seas='JFM2018';endif;
return seas

