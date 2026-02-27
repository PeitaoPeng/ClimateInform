'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open stdprate.oct13-mar14.ctl'
'open mask_land_sea_edge.lnx.ctl'
'open stdt2m.oct13-mar14.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 4.25 10.2 Standardized Prate & T2m Anom'
*---------------------------set dimsnesion, page size and style
nframe=8
nframe2=4
nframe3=8
xmin0=1.0;  xlen=3.;  xgap=0.5
ymax0=10.; ylen=-2.;  ygap=-0.3
*
'define pt1=maskout(p(t=3),mask.2(t=1)-1)'
'define pt2=maskout(p(t=4),mask.2(t=1)-1)'
'define pt3=maskout(p(t=5),mask.2(t=1)-1)'
'define pt4=maskout(p(t=6),mask.2(t=1)-1)'
'define pt5=t2m.3(t=3)'
'define pt6=t2m.3(t=4)'
'define pt7=t2m.3(t=5)'
'define pt8=t2m.3(t=6)'
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
  tlx=xmin-0.6
  tly=ymax-2.
  bx=xmin+1.5
  by=ymin-0.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lon 190 310'
'set lat  10 90'
*'set yaxis 10 90 20'
'set xlab off'
'set ylab off'
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
if(iframe <= 4);
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2'
'set ccols   79 77 75 73 71 0 31 33 35 37 39'
endif
if(iframe > 4);
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2'
'set ccols   49 47 45 43 41 21 23 25 27 29'
endif
'd pt'%iframe
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
*'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 90'
'set string 1 tl 6 0'
'set strsiz 0.15 0.15'
if(iframe = 4); 'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''; endif
if(iframe = 8); 'run /cpc/home/wd52pp/bin/cbarn2.gs 0.5 0 'bx' 'by''; endif

'set string 1 tl 6 90'
'set strsiz 0.15 0.15'
if(iframe = 1); 'draw string 'tlx' 'tly' (a) Dec 2013'; endif
if(iframe = 2); 'draw string 'tlx' 'tly' (b) Jan 2014'; endif
if(iframe = 3); 'draw string 'tlx' 'tly' (c) Feb 2014'; endif
if(iframe = 4); 'draw string 'tlx' 'tly' (d) Mar 2014'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
*'run /cpc/home/wd52pp/bin/cbarn2.gs 1. 1 'bx' 'by''
'print'
'printim t_p.dec13-mar14.png gif x600 y800'

