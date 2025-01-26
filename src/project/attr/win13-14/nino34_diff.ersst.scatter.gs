'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open nino34.ndjfm.ersst.1949-2013.ctl'
'open eqgrad.ndjfm.ersst.1949-2013.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 6'
 'set strsiz 0.14 0.14'
'draw string 5.5 7.25  -NINO3.4 SST vs WSSTA-ESSTA'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=2.5;  xlen=6.;  xgap=0.1
ymax0=7.; ylen=-6.;  ygap=-0.5
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
  my1=ymin+2.2
  my2=ymin+2.
  sx1=mx1+0.15
  sx2=mx2+0.15
  sy1=my1+0.08
  sy2=my2+0.08
  kx1=xmin+1.75
  kx2=xmin-0.6
  ky1=ymin-0.25
  ky2=ymin+1.
  ktlx=xmin-0.0
  ktly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set xaxis 1949 2013 5'
*
'set gxout scatter'
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set t 1 65'
'deifne diff=west.2-east.2'
'set y 1'
'set ylint 0.5'
'set vrange -2.5 2.5 0.5'
'set vrange2 -2.5 2.5 0.5'
*'set yaxis -2.5 2.5 0.5'
'set ccolor 1'
'set cmark 5'
'd -sst;(west.2-east.2)'
'draw xlab -NINO3.4 SST'
'draw ylab WSSTA-ESSTA'
*'run /cpc/home/wd52pp/bin/dline.gs 0 0 65 0'
*'draw string 'tlx' 'tly' (a) Nino3.4 Index vs Z200 Persistency'
*'draw mark 8 'mx1' 'my1' 0.1'
'set string 29 tl 5 0'
*'draw string 'sx1' 'sy1' -Nino3.4'
*'draw mark 5 'mx2' 'my2' 0.1'
'set string 49 tl 5 0'
*'draw string 'sx2' 'sy2' WSSTA-ESSTA'
iframe=iframe+1
endwhile
'print'
'printim nino34_diff.ersst.scatter.png gif x800 y600'
*'c'
*'set vpage off'
*----------
*
*----------
