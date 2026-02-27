'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pers_vs_yr.1949-2013.ctl'
'open nino34.ndjfm.ersst.1949-2013.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*'draw string 4.25 9.6 NDJFM Mean NINO3.4 SST(K) and Z200 Persistency'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.5;  xlen=5.5;  xgap=0.1
ymax0=9.4; ylen=-3.;  ygap=-0.5
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
  bx=xmin-0.1
  by=ymin-0.5
  sx1=xmin+2.725
  sx2=xmin-0.5
  sy1=ymin-0.30
  sy2=ymin+1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set gxout scatter'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set t 1 65'
'set ylint 1'
'set vrange2 0.5 5.5 1'
'set vrange 0 2.5 0.5'
*'set yaxis  0 2.5 0.5'
'set ccolor 29'
if (iframe = 1)
'set gxout line'
'set ccolor 1'
'set cmark 8'
*'d p3;abs(sst.2)'
'd abs(sst.2);p1'
'set ccolor 1'
'set cmark 8'
'd abs(sst.2);p2*2'
'set ccolor 1'
'set cmark 8'
'd abs(sst.2);p3*3'
'set ccolor 1'
'set cmark 8'
'd abs(sst.2);p4*4'
'set ccolor 1'
'set cmark 8'
'd abs(sst.2);p5*5'
'set ccolor 1'
'set cmark 8'
'set cmark 5'
'set ccolor 1'
'run /cpc/home/wd52pp/bin/dline.gs 0 1. 2.5 5.'
'set string 1 tc 5 90'
'draw string 'sx2' 'sy2' Degree of Persistence(mon)'
'set string 1 tc 5 0'
'draw string 'sx1' 'sy1' ABS NINO3.4 SST(K)'
'set string 1 tl 5 0'
endif
iframe=iframe+1
endwhile
'print'
'printim pers_vs_nino34.scatter.obs.png gif x600 y800'
*'c'
*'set vpage off'
*----------
*
*----------
