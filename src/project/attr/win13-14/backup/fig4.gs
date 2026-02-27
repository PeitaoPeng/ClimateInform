'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*'open /cpc/home/wd52pp/data/attr/win13-14/bmout.dec13.ttfrc.ctl'
*'open /cpc/home/wd52pp/data/attr/win13-14/bmout.jan14.ttfrc.ctl'
*'open /cpc/home/wd52pp/data/attr/win13-14/bmout.feb14.ttfrc.ctl'
*'open /cpc/home/wd52pp/data/attr/win13-14/bmout.mar14.ttfrc.ctl'
*'open prate.oct13-mar14.tp.ctl'
'open /cpc/home/wd52pp/project/attr/win13-14/psi_div.ndjfm2013-14.mon.para.esm.T40.ctl'
*'open /cpc/home/wd52pp/project/attr/win13-14/prate.ndjfm2013-14.mon.para.esm.ctl'
'open /cpc/home/wd52pp/project/attr/win13-14/prate.nov13-mar14.esm.ctl'

*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
*'draw string 4.25 10.5 200mb STRM(10`a6`nm`a2`n/s) Anom and Wave Flux'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
nframe3=4
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.25;  ygap=-0.05
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
  tlx=xmin-0.4
  tly=ymax-1.55
  bx=xmax+0.2
  by=5.45
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'define st1=sfo'
*'define st2=sfo.2'
*'define st3=sfo.3'
*'define st4=sfo.4'
'define st1=psi(time=dec2013)'
'define st2=psi(time=jan2014)'
'define st3=psi(time=feb2014)'
'define st4=psi(time=mar2014)'
'define p1=z.2(time=dec2013)'
'define p2=z.2(time=jan2014)'
'define p3=z.2(time=feb2014)'
'define p4=z.2(time=mar2014)'
*'define u1=xflxo'
*'define u2=xflxo.2'
*'define u3=xflxo.3'
*'define u4=xflxo.4'
*'define v1=yflxo'
*'define v2=yflxo.2'
*'define v3=yflxo.3'
*'define v4=yflxo.4'
*'define u1=skip(xflxo,2,2)'
*'define u2=skip(xflxo.2,2,2)'
*'define u3=skip(xflxo.3,2,2)'
*'define u4=skip(xflxo.4,2,2)'
*'define v1=skip(yflxo,2,2)'
*'define v2=skip(yflxo.2,2,2)'
*'define v3=skip(yflxo.3,2,2)'
*'define v4=skip(yflxo.4,2,2)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 20'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab off'
if(iframe = 4); 'set xlab on'; endif
'set arrlab off'
if(iframe = 4); 'set arrlab on'; endif
'set gxout shaded'
'set clevs   -4 -3 -2 -1 -0.5 0.5 1 2 3 4'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd p'%iframe
'set gxout contour'
'set ccolor 1'
'set cint 2'
'd 0.000001*st'%iframe
'set ccolor 1'
*'set arrscl  0.4 100'
*'set arrowhead 0.05'
if(iframe = 1)
*'d maskout(u1,sqrt(u1*u1+v1*v1)-10);maskout(v1,sqrt(u1*u1+v1*v1)-10)';
endif
if(iframe = 2)
*'d maskout(u2,sqrt(u2*u2+v2*v2)-10);maskout(v2,sqrt(u2*u2+v2*v2)-10)';
endif
if(iframe = 3)
*'d maskout(u3,sqrt(u3*u3+v3*v3)-10);maskout(v3,sqrt(u3*u3+v3*v3)-10)';
endif
if(iframe = 4)
*'d maskout(u4,sqrt(u4*u4+v4*v4)-10);maskout(v4,sqrt(u4*u4+v4*v4)-10)';
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
'set string 1 tl 5 90'
'set strsiz 0.13 0.13'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec13'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Jan14'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Feb14'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) Mar14'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim fig4.png gif x1200 y1600'

