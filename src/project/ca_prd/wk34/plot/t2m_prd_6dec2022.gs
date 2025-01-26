'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/wk34_fcst/ca/2022/12/06/ca_sat_wk34.ctl'
*
*---------------------------string/caption
 'set string 1 tc 3'
 'set strsiz 0.13 0.13'
'draw string 5.5 8.2 CA SAT Forecast, IC: Dec04,2022'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=4.5;  xgap=0.6
ymax0=7.5; ylen=-2.75;  ygap=-0.75
*
'define z1=wk2'
'define z2=wk3'
'define z3=wk4'
'define z4=w34'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.25
  titly=ymax+0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 190 305'
'set lat 10 80'
*'set lon 0 360'
*'set lat -90 90'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs    -2.5 -2 -1.5 -1 -0.5 0 0.5 1 1.5 2 2.5'
'set ccols    49 47 45 43 42 41 21 22 23 25 27 29'
*'set yaxis -30 30 10'
'd z'%iframe
 'set strsiz 0.13 0.13'
if(iframe = 1);'draw string 'titlx' 'titly' WK2';endif 
if(iframe = 2);'draw string 'titlx' 'titly' WK3';endif 
if(iframe = 3);'draw string 'titlx' 'titly' WK4';endif 
if(iframe = 4);'draw string 'titlx' 'titly' WK34';endif 
*
iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 5.5 0.5'
endwhile
'printim ca_t2m_fcst_6dec2022.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
