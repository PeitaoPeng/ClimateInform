'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/ca_prd/sat.7drm.1979-curr.ctl'
*
*---------------------------string/caption
 'set string 1 tc 3'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.75 OBS Mean T2m Anom: 16-29DEC2022'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=2.;  xlen=7.;  xgap=0.6
ymax0=7.5; ylen=-5.;  ygap=-0.75
*
'define z1=ave(t,time=16dec2022,time=29dec2022)'
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
*'set clevs    -3 -2.5 -2 -1.5 -1 -0.5 0.5 1 1.5 2 2.5 3.'
'set clevs    -20 -10 -8 -4 -2 -0.5 0.5 2 4 8 10 20'
'set ccols    49 48 47 45 43 41 0 21 23 25 27 28 29'
*'set yaxis -30 30 10'
'd z'%iframe
 'set strsiz 0.13 0.13'
*if(iframe = 1);'draw string 'titlx' 'titly' WK2';endif 
if(iframe = 2);'draw string 'titlx' 'titly' WK3';endif 
if(iframe = 3);'draw string 'titlx' 'titly' WK4';endif 
if(iframe = 4);'draw string 'titlx' 'titly' WK34';endif 
*
iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 0 5.5 1.8'
endwhile
'printim ca_t2m_OBS_01dec2022.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
