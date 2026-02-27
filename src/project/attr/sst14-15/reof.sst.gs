'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/eof.sst.had-oi.feb1949-cur.3mon.tnp.ctl'
*
'set string 1 tc 5'
'set strsiz 0.15 0.15'
'draw string 5.5 7.5 REOFs of TNP SST jfm1949-jfm2015'
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
'define s1=-rreg(t=1)'
'define s2=-rreg(t=2)'
'define s3=rreg(t=3)'
'define s4=-rreg(t=4)'
'define s5=-rreg(t=5)'
'define s6=-rreg(t=6)'
'set t 1'
'set lon 0 360'
'set lat  -30 65'
'set yaxis -30 65 15'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs   -1.0 -0.7 -0.4 -0.2 -0.1 0.1 0.2 0.4 0.7 1.0'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'd s'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
'run /cpc/home/wd52pp/bin/dline.gs 180 -30 180 65'
'set string 1 tl 6 0'
'set strsiz 0.14 0.14'
if(iframe = 1); 'draw string 'tlx' 'tly'  REOF1 27.4%'; endif
if(iframe = 2); 'draw string 'tlx' 'tly'  REOF2 8.6%'; endif
if(iframe = 3); 'draw string 'tlx' 'tly'  REOF3 7.8%'; endif
if(iframe = 4); 'draw string 'tlx' 'tly'  REOF4 6.6%'; endif
if(iframe = 5); 'draw string 'tlx' 'tly'  REOF5 5.1%'; endif
if(iframe = 6); 'draw string 'tlx' 'tly'  REOF6 4.5%'; endif
'set string 1 tl 5 0'

iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.75 0 'bx' 'by''
'print'
'printim reof.sst.3mon.png gif x1600 y1200'

