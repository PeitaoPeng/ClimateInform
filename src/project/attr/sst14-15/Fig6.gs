'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/corr.pc1.vs.pc3.lag-lead.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*'draw string 4.25 9.0 PCs of TNP SST'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.5;  xlen=5.5;  xgap=0.1
ymax0=10; ylen=-3;  ygap=-0.5
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
  mx1=xmin+0.5
  mx2=xmin+0.5
  my1=ymax-0.3
  my2=ymin+2.
  sx1=mx1+0.15
  sx2=mx2+0.15
  sy1=my1+0.08
  sy2=sy1-0.25
  kx0=xmin+2.75
  kx1=xmin+1.35
  kx2=4.25+1.35
  ky0=ymin-0.3
  ky1=ymin-0.5
  ky2=ymin+1.
  ktlx=xmin-0.6
  ktly=ymax-1.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set grads off'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set t 1 9'
'set xlabs -4|-3|-2|-1|0|1|2|3|4'
'set y 1'
'set ylint 0.1'
'set vrange -0.2 0.5 0.1'
'set yaxis -0.2 0.5 0.1'
'set gxout bar'
'set bargap 30'
'set barbase 0'
'set ccolor 58'
'd maskout(cor,-cor)'
'set ccolor 28'
'd maskout(cor,cor)'
*'run /cpc/home/wd52pp/bin/dline.gs 780 0 792 0'
'set string 1 tl 5 0'
'set string 2 tl 5 0'
'set string 1 tc 5 90'
'draw string 'ktlx' 'ktly' CORR'
'set string 1 tc 5 0'
'draw string 'kx0' 'ky0' LEAD(year)'
'set strsiz 0.11 0.11'
'draw string 'kx1' 'ky1' PC3 Lead PC1'
'draw string 'kx2' 'ky1' PC1 Lead PC3'
iframe=iframe+1
endwhile
'print'
'printim Fig6.png gif x1200 y1600'
*'c'
*'set vpage off'
*----------
*
*----------
