titmon='Mar 2003'
*
'open casst.ctl'
'open mask.ctl'
*
'set display color white'
'clear'
*
'run /nfsuser/g01/wx23ss/gscripts/rgbset.gs'
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
'draw string 0.12 0.12 Huug van den Dool, CPC/NCEP/NWS/NOAA                    Base Period 1971-2000'
*
*grfile='casst.'lead'.'yyyymm'.gr'
*say "grfile "grfile
*'enable print 'grfile
*
giffile='casst.'lead'.gif'
say "giffile "giffile
*
'set t 'tx
'define sstfull=maskout(sst.1-273.16,0.1-land.2(t=1))'
*
'set grads off'
'set gxout shaded'
'set clevs 0  3  6  9 12 15 18 21 24 27 27.5 28 28.5 29 29.5 30 30.5 31'
'set ccols 0 49 48 47 46 45 44 43 42 41   61 62   63 64   65 66   67 68 69'
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
'set clevs 0  3  6  9 12 15 18 21 24'
'set clab off'
'd sstfull'
*
'set gxout contour'
'set ccolor 69'
'set clevs 27 27.5 28 28.5 29 29.5 30 30.5 31'
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
if(time=1);seas='Mar2003';endif;
if(time=2);seas='Apr2003';endif;
if(time=3);seas='May2003';endif;
if(time=4);seas='Jun2003';endif;
if(time=5);seas='Jul2003';endif;
if(time=6);seas='Aug2003';endif;
if(time=7);seas='Sep2003';endif;
if(time=8);seas='Oct2003';endif;
if(time=9);seas='Nov2003';endif;
if(time=10);seas='Dec2003';endif;
if(time=11);seas='Jan2004';endif;
if(time=12);seas='Feb2004';endif;
if(time=13);seas='Mar2004';endif;
if(time=14);seas='Apr2004';endif;
if(time=15);seas='May2004';endif;
return seas
