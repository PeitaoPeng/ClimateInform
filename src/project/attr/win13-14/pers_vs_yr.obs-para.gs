'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
'draw string 4.25 10.0 Variation of Persistence with Time'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
xmin0=1.;  xlen=6.5;  xgap=0.1
ymax0=9.5; ylen=-2.5;  ygap=-0.75
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
  tlx=xmin-0.0
  tly=ymax+0.2
  ylbx=xmin-0.5
  ylby=ymin+1.25
  dx=0.75
  cx1=xmin+dx
  cx2=cx1+dx
  cx3=cx2+dx
  cy=ymin+2.2

* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set grads off'
'set grid off'
*
if(iframe = 1);
'open pers_vs_yr.1949-2013.ctl'
'set gxout line'
'set t 1 65'
'set vrange 2 5'
'set yaxis 2 5 1'
'set cmark 3' 
'set ccolor 2'
'd p3*3'
'set cmark 3' 
'set ccolor 3'
'd p4*4'
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
'draw string 'tlx' 'tly' (a) OBS'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
'draw string 'ylbx' 'ylby' Months of Persistence'
endif
if(iframe = 2);
'open pers_vs_yr.1957-2013.para.ctl'
'set t 9 65'
'set gxout bar'
'set barbase 0'
'set bargap 30'
'set ccolor 25'
'd pt.2'
'set gxout line'
'set t 14 60'
'define smpt=ave(pt.2,t-5,t+5)'
'set cmark 0'
'set cstyle 1'
'set cthick 7'
'set ccolor 3'
'set t 9 65'
'd smpt'
'set string 1 tl 5 0'
'set strsiz 0.12 0.12'
'draw string 'tlx' 'tly' (b) AGCM'
'set string 1 tc 5 90'
'set strsiz 0.12 0.12'
'draw string 'ylbx' 'ylby' # of Ensemble Members'
endif
*
iframe=iframe+1
endwhile
'print'
'printim pers_vs_yr.obs-para.png gif x600 y800'
