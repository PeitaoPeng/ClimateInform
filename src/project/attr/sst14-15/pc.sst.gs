'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/pc.sst.had-oi.feb1949-cur.3mon.tnp.ctl'
'open eqgrad.ndjfm.ersst.1949-2013.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
'draw string 5.5 7.20 PCs of TNP SST'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
nframe3=1
xmin0=0.75;  xlen=9.5;  xgap=0.1
ymax0=7; ylen=-6;  ygap=-0.5
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
  my1=ymax-0.25
  my2=ymin+2.
  sx1=mx1+0.15
  sx2=mx2+0.15
  sy1=my1+0.08
  sy2=sy1-0.25
  sy3=sy2-0.25
  sy4=sy3-0.25
  sy5=sy4-0.25
  sy6=sy5-0.25
  kx1=xmin+1.75
  kx2=xmin-0.6
  ky1=ymin-0.25
  ky2=ymin+1.
  ktlx=xmin-0.0
  ktly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set grads off'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
'set time jan2013 feb2015'
'set y 1'
'set ylint 0.5'
'set vrange -4. 4. 0.5'
'set yaxis -4. 4. 0.5'
'set ccolor 1'
'set cmark 0'
'd -pc1'
'set ccolor 2'
'set cmark 0'
'd pc2'
'set ccolor 3'
'set cmark 0'
'd -pc3'
'set ccolor 4'
'set cmark 0'
*'d -pc4'
'set ccolor 5'
'set cmark 0'
*'d pc5'
'set ccolor 8'
'set cmark 0'
*'d pc6'
'run /cpc/home/wd52pp/bin/dline.gs 408 0 432 0'
'set string 1 tl 5 0'
'draw string 'sx1' 'sy1' PC1'
'set string 2 tl 5 0'
'draw string 'sx1' 'sy2' PC2'
'set string 3 tl 5 0'
'draw string 'sx1' 'sy3' PC3'
'set string 4 tl 5 0'
*'draw string 'sx1' 'sy4' PC4'
'set string 5 tl 5 0'
*'draw string 'sx1' 'sy5' PC5'
'set string 8 tl 5 0'
*'draw string 'sx1' 'sy6' PC6'
iframe=iframe+1
endwhile
'print'
'printim pc.sst.png gif x800 y600'
*'c'
*'set vpage off'
*----------
*
*----------
