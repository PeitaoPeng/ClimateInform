'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open psi_div.clim_anom.ndjfm2013-14.mon.para.esm.T40.ctl'
'open prate.ndjfm2013-14.mon.para.esm.144x73.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 AMIP Prate(mm/day) & 200mb PSI(10`a6`nm`a2`n/s) Anom'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.0;  ygap=-0.05
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
  tlx=xmin-0.2
  tly=ymax-1.5
  bx=xmax+0.
  by=ymax+2.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define p1=z.2(t=2)'
'define p2=z.2(t=3)'
'define p3=z.2(t=4)'
'define p4=z.2(t=5)'
'define st1=psia(t=2)-ave(psia(t=2),lon=0,lon=360)'
'define st2=psia(t=3)-ave(psia(t=3),lon=0,lon=360)'
'define st3=psia(t=4)-ave(psia(t=4),lon=0,lon=360)'
'define st4=psia(t=5)-ave(psia(t=5),lon=0,lon=360)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd 86400*p'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd 0.000001*st'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec13'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Jan14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Feb14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) Mar14'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim prate_psi.dec13-mar14.para.png gif x600 y800'

