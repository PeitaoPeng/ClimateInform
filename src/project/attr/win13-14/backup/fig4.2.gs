'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open psi_vlp.clim_anom.ndjfm2013-14.mon.para.esm.T40.ctl'
'open prate.ndjfm2013-14.mon.para.esm.144x73.ctl'
'open psi_div.ndjfm2013-14.mon.para.toga.esm.T40.ctl'
'open prate.ndjfm2013-14.mon.para.toga.esm.144x73.ctl'
*
'set string 1 tc 5'
'set strsiz 0.13 0.13'
*'draw string 4.25 10 AGCM Prate & 200mb PSI Anom, DJFM'
*---------------------------set dimsnesion, page size and style
'define ps1=ave(psia,t=2,t=5)'
'define ps2=ave(psi.3,t=2,t=5)'
'define prate1=86400*ave(z.2,t=2,t=5)'
'define psi1=0.000001*(ps1-ave(ps1,x=1,x=144))'
'define prate2=86400*ave(z.4,t=2,t=5)'
'define psi2=0.000001*(ps2-ave(ps2,x=1,x=144))'
'define prate3=86400*ave(z.2-z.4,t=2,t=5)'
'define psi3=psi1-psi2'
nframe=3
nframe2=3
nframe3=3
xmin0=1.25;  xlen=6;  xgap=0.2
ymax0=10; ylen=-3.;  ygap=-0.15
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
  tlx=xmin+0.
  tly=ymax+0.
  bx=4.25
  by=ymin-0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 0 360'
'set lat  -40 90'
*'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols 79 77 75 73 71 0 31 33 35 37 39'
'd prate'%iframe
'set gxout contour'
'set cint 1'
'set ccolor 4'
'd psi'%iframe
*'set gxout vector'
*'set arrscl  0.5 100'
*'set arrowhead 0.05'
*'d xflxd;yflxd'
*'d maskout(u1,sqrt(u1*u1+v1*v1)-10);maskout(v1,sqrt(u1*u1+v1*v1)-10)';
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 5 0'
'set strsiz 0.13 0.13'
if(iframe=1);'draw string 'tlx' 'tly' a)GOGA';endif
if(iframe=2);'draw string 'tlx' 'tly' b)TOGA';endif
if(iframe=3);'draw string 'tlx' 'tly' c)GOGA-TOGA';endif

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim fig4.png gif x1200 y1600'

