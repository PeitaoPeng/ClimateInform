'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/adam/real_prd.psi200_wkly.ctl'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
'draw string 5.5 7.2 Week3-4 Forecast for 200mb Stream Function'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.0;  xlen=9.;  xgap=1.0
ymax0=7.; ylen=-3.5;  ygap=-0.5
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
*'set mproj scaled'
'set lon 0 360'
'set lat -20 85'
*'set xlab off'
'set grads off'
*'set grid off'
'd pw34'
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''
 'set string 1 tc 5'
 'set strsiz 0.15 0.15'
endwhile
'printim wk34_psi200_fcst.png gif x1600 y1200'
'print'
*
*'c'
'set vpage off'
