'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open psi_vlp.ndjfm2013-14.mon.para.esm.T40.ctl'
'open psi_div.ndjfm2013-14.mon.para.toga.esm.T40.ctl'
'open prate.ndjfm2013-14.mon.para.esm.144x73.ctl'
'open prate.ndjfm2013-14.mon.para.toga.esm.144x73.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 GOGA-TOGA Prate (mm/day) and 200mb PSI(10`a6`nm`a2`n/s) Anom, DJFM2013/14'
*---------------------------set dimsnesion, page size and style
'define prate=ave(z.3,t=2,t=5)'
'define prate2=ave(z.4,t=2,t=5)'
'define strm=ave(psi,t=2,t=5)'
'define strm2=ave(psi.2,t=2,t=5)'
nframe=1
nframe2=1
nframe3=1
xmin0=1.;  xlen=9;  xgap=0.2
ymax0=8.; ylen=-7;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  tlx=xmin-0.5
  tly=ymax-2.
  bx=5.5
  by=ymin+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 0 360'
'set lat  -90 90'
'set yaxis -90 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout contour'
'set ccolor 4'
'set gxout shaded'
'set clevs -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd 86400*(prate-prate2)'
'set gxout contour'
'set cint 1'
'd 0.000001*(strm-strm2-ave(strm-strm2,x=1,x=144))'
'set gxout vector'
*'set arrscl  0.5 100'
*'set arrowhead 0.05'
*'d xflxd;yflxd'
*'d maskout(u1,sqrt(u1*u1+v1*v1)-10);maskout(v1,sqrt(u1*u1+v1*v1)-10)';
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -90 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 0 'bx' 'by''
'print'
'printim prate_psi.djfm.goga-toga.png gif x800 y600'

