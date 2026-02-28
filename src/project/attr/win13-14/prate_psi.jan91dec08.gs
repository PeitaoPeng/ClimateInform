'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open psi200.ndjfm1949-curr.mon.ctl'
'open prate.ndjfm.1979-curr.mon.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.3 Prate(mm/day) & PSI200(10`a6`nm`a2`n/s) Anom'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.5;  xlen=5.5;  xgap=0.2
ymax0=9.75; ylen=-2.0;  ygap=-0.6
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
  tlx=xmin+0.35
  tly=ymax+0.2
  bx=xmax+0.
  by=ymax+0.25
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'define st1=zj(t=42)-ave(zj(t=42),lon=0,lon=360)'
'define st2=zd(t=60)-ave(zd(t=60),lon=0,lon=360)'
'set t 1'
'set lon 0 360'
'set lat  -40 90'
'set yaxis -40 90 30'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab on'
'set gxout shaded'
'set clevs   -6 -4 -2 -1 -0.5 0.5 1 2 4 6'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
if(iframe = 1); 
'set t 42';
'd pj.2'
endif
if(iframe = 2); 
'set t 60';
'd pd.2'
endif
'set gxout contour'
'set ccolor 1'
'set cint 5'
if(iframe = 1); 
'set t 42';
'd 0.000001*st1'
endif
if(iframe = 2); 
'set t 60';
'd 0.000001*st2'
endif
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -40 180 90'
*'set string 1 tl 6 90'
'set string 1 tl 5 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Jan1991'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Dec2008'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.8 1 'bx' 'by''
'print'
'printim prate_psi.jan91dec08.png gif x600 y800'

