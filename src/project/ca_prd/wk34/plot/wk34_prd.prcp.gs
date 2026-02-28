'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/adam/real_wk34_prcp_prd.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
'draw string 5.5 8 CA Prec Week3-4 Forecast'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
'define prd1=100*prb'
'define prd2=hss'
nframe=2
nframe2=1
xmin0=1.0;  xlen=4.;  xgap=1.0
ymax0=7.; ylen=-3.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  bx=xmin+2.
  by=ymin-0.5
  titlx=xmin+2.
  titly=ymax+0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 190 305'
'set lat 15 75'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
if(iframe = 1);
'set clevs   -90 -80 -70 -55 55 70 80 90'
'set ccols  78 76 74 72 0 32 34 36 38'
'draw string 'titlx' 'titly' Prec (prob in %)'
endif
if(iframe = 2);
'set clevs    10 20 30 40 50 60'
'set ccols  0 21 23 24 25 27 29'
'draw string 'titlx' 'titly' HSS'
endif
'd prd'%iframe
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
endwhile
'printim wk34_prcp_fcst.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
