'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/djf14-15/corr.sstpc.vs.sz.1949-cur.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 Regr&Corr of PSI200 to SST RPCs jfm1949-jfm2015'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
nframe3=6
xmin0=0.75;  xlen=4.5;  xgap=0.5
ymax0=7.5; ylen=-2.25;  ygap=0.4
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
  tlx=xmin+0.3
  tly=ymax-0.5
  bx=5.5
  by=ymin-0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'define s1=-rsreg(t=1)'
'define s2=-rsreg(t=2)'
'define s3=rsreg(t=3)'
'define s4=rsreg(t=4)'
'define s5=-rsreg(t=5)'
'define s6=-rsreg(t=6)'
'define c1=-rscor(t=1)'
'define c2=-rscor(t=2)'
'define c3= rscor(t=3)'
'define c4=rscor(t=4)'
'define c5=-rscor(t=5)'
'define c6=-rscor(t=6)'
'set t 1'
'set lon 0 360'
'set lat  -30 90'
'set yaxis -30 90 20'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
 'set gxout shaded'
 'set clevs   -0.5 -0.4 -0.3 -0.2 -0.1 0.1 0.2 0.3 0.4 0.5'
 'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd c'%iframe
'set gxout contour'
'set cint 5'
'd 0.00001*s'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 65'
'set string 6 tl 6 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly'  RPC1'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  RPC2'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  RPC3'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  RPC4'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  RPC5'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  RPC6'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim regr.psi.vs.sstrpc.3mon.png gif x1600 y1200'

