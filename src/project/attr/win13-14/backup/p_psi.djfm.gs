'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/project/attr/win13-14/hgt_strm_vpot.200mb.oct13-mar14.ctl'
'open /cpc/home/wd52pp/project/attr/win13-14/prate.oct13-mar14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 200mb PSI(10`a6`nm`a2`n/s) Anom & Prate(mm/day), DJFM2013/14'
*---------------------------set dimsnesion, page size and style
'define prate=ave(p.2,t=3,t=6)'
'define psi=ave(strm,t=3,t=6)'
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
'set clevs -3 -2 -1 -0.5 0.5 1 2 3'
'set ccols  78 76 74 72 0 32 34 36 38'
'd prate'
'set gxout contour'
'set cint 2'
'd 0.000001*(psi-ave(psi,x=1,x=144))'
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
'printim prate_psi.djfm.png gif x800 y600'

