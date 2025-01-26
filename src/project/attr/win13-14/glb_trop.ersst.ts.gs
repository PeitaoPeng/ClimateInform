'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open gltrop.ndjfm.ersst.1949-2013.ctl'
'open glb.ndjfm.ersst.1949-2013.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
'draw string 4.25 9.6 NDJFM Mean GLB and TROP SST(K)'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=1.;  xlen=6.5;  xgap=0.1
ymax0=9.4; ylen=-2.5;  ygap=-0.5
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
  sy1=my1+0.06
  sy2=my2+0.06
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
'set xaxis 1949 2013 5'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set t 1 65'
'set y 1'
'set ylint 0.5'
'set vrange -1. 1. 0.2'
'set yaxis -1 1 0.5'
'set ccolor 29'
'set cmark 0'
'd sst'
'set ccolor 49'
'set cmark 0'
'd sst.2'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 65 0'
*'draw string 'tlx' 'tly' (a) Nino3.4 Index vs Z200 Persistency'
*'draw mark 8 'mx1' 'my1' 0.1'
'set string 29 tl 5 0'
'draw string 'sx1' 'sy1' Tropical (20S-20N)'
*'draw mark 5 'mx2' 'my2' 0.1'
'set string 49 tl 5 0'
'draw string 'sx2' 'sy2' Global'
iframe=iframe+1
endwhile
'print'
'printim glb_trop.ersst.ts.png gif x600 y800'
*'c'
*'set vpage off'
*----------
*
*----------
