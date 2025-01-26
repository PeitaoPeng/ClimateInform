titmon='Oct 2016'
*
'open cassta.ctl'
'open mask.ctl'
*
'set display color white'
'clear'
*
'run /global/save/Suranjana.Saha/gscripts/rgbset.gs'
*
ts=1
te=15
*
tx=ts
while(tx<=te)
*
seas=getseas(tx)
lead=tx-2
*
'set strsiz 0.1'
'set string 4 tl 6'
'draw string 0.12 0.12 Huug van den Dool, CPC/NCEP/NWS/NOAA                    Base Period 1981-2010'
*
*grfile='casst_anom.'lead'.'yyyymm'.gr'
*say "grfile "grfile
*'enable print 'grfile
*
giffile='casst_anom.'lead'.gif'
say "giffile "giffile
*
'set t 'tx
'define sstfull=maskout(sst.1,0.1-land.2(t=1))'
*
'set grads off'
'set gxout shaded'
'set clevs -2.4 -2 -1.6 -1.2 -0.8 -0.4 0 0.4 0.8 1.2 1.6 2.0 2.4'
'set ccols 48  47 46   44   43  42 0 0 62 63  64 66 67 68'
#'set clevs 0  3  6  9 12 15 18 21 24 27 27.5 28 28.5 29 29.5 30 30.5 31'
#'set ccols 0 49 48 47 46 45 44 43 42 41   61 62   63 64   65 66   67 68 69'
'd sstfull'
'run /global/save/Suranjana.Saha/gscripts/cbar.gs'
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
'set clevs -2.4 -2 -1.6 -1.2 -0.8 -0.4'
'set clab off'
'd sstfull'
*
'set gxout contour'
'set ccolor 69'
#'set clevs 27 27.5 28 28.5 29 29.5 30 30.5 31'
'set clevs  0.4 0.8 1.2 1.6 2.0 2.4'
'set clab off'
'd sstfull'
*
'set ccolor 1'
'set clevs 29 29.5 30 30.5 31'
'set clab off'
'd sstfull'
*
'draw title SST Constructed Analogue Forecast : Lead 'lead' : 'seas' \ (last data used thru 'titmon' )'
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
if(time=1);seas='Oct2016';endif;
if(time=2);seas='Nov2016';endif;
if(time=3);seas='Dec2016';endif;
if(time=4);seas='Jan2017';endif;
if(time=5);seas='Feb2017';endif;
if(time=6);seas='Mar2017';endif;
if(time=7);seas='Apr2017';endif;
if(time=8);seas='May2017';endif;
if(time=9);seas='Jun2017';endif;
if(time=10);seas='Jul2017';endif;
if(time=11);seas='Aug2017';endif;
if(time=12);seas='Sep2017';endif;
if(time=13);seas='Oct2017';endif;
if(time=14);seas='Nov2017';endif;
if(time=15);seas='Dec2017';endif;
return seas
