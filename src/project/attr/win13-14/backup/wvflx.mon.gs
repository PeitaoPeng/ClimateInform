'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.dec13.ttfrc.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.jan14.ttfrc.ctl'
'open /cpc/home/wd52pp/data/attr/winter13-14/bmout.feb14.ttfrc.ctl'
'open prate.oct13-feb14.tp.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.5 200mb STRM(10`a6`nm`a2`n/s) Anom and Wave Flux'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
nframe3=3
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=10.; ylen=-2.5;  ygap=-0.65
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
  bx=xmax+0.5
  by=ymax+1.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define st1=sfo'
'define st2=sfo.2'
'define st3=sfo.3'
'define p1=p.4(t=3)'
'define p2=p.4(t=4)'
'define p3=p.4(t=5)'
'define u1=skip(xflxo,2,2)'
'define u2=skip(xflxo.2,2,2)'
'define u3=skip(xflxo.3,2,2)'
'define v1=skip(yflxo,2,2)'
'define v2=skip(yflxo.2,2,2)'
'define v3=skip(yflxo.3,2,2)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs   -8 -4 -2 -1 -0.5 0.5 1 2 4 8'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
'd p'%iframe
'set gxout contour'
'set gxout contour'
'set ccolor 4'
'set cint 4'
'd 0.000001*st'%iframe
'set ccolor 1'
'set arrscl  0.5 100'
'set arrowhead 0.05'
if(iframe = 1)
'd maskout(u1,sqrt(u1*u1+v1*v1)-10);maskout(v1,sqrt(u1*u1+v1*v1)-10)';
endif
if(iframe = 2)
'd maskout(u2,sqrt(u2*u2+v2*v2)-10);maskout(v2,sqrt(u2*u2+v2*v2)-10)';
endif
if(iframe = 3)
'd maskout(u3,sqrt(u3*u3+v3*v3)-10);maskout(v3,sqrt(u3*u3+v3*v3)-10)';
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 90'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec 2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Jan 2014'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Feb 2014'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim p_strm_wvflx.dec13-feb14.png gif x600 y800'

