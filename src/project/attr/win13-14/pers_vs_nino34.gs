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
'draw string 4.25 9.6 NDJFM Mean NINO3.4 SST(K) and Z200 Persistency'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
nframe3=2
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
'set t 1'
*
'set gxout bar'
'set bargap 50'
'set barbase 0'
'set xaxis 1949 2013 5'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set t 1 65'
'set y 1'
'set ylint 0.5'
'set vrange -2. 3. 0.5'
'set yaxis -2 3 0.5'
'set ccolor 29'
if (iframe = 1)
'd maskout(sst.2,sst.2)'
'set ccolor 49'
'd maskout(sst.2,-sst.2)'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 65 0'
'set gxout line'
'set ccolor 1'
'set cmark 8'
'd p3'
'set ccolor 1'
'set cmark 5'
'd p4'
*'draw string 'tlx' 'tly' (a) Nino3.4 Index vs Z200 Persistency'
'draw mark 8 'mx1' 'my1' 0.1'
'draw string 'sx1' 'sy1' 3-mon persistence'
'set ccolor 1'
'draw mark 5 'mx2' 'my2' 0.1'
'draw string 'sx2' 'sy2' 4-mon persistence'
endif
iframe=iframe+1
endwhile
'print'
'printim pers_vs_nino34.png gif x600 y800'
*'c'
*'set vpage off'
*----------
*
*----------
