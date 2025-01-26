'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open /cpc/home/wd52pp/data/attr/sst14-15/pc.sst.had-oi.dec1949-dec2014.djf.tnp.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.13 0.13'
*'draw string 4.25 7.20 PCs of TNP SST'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
nframe3=3
xmin0=1.25;  xlen=6.;  xgap=0.1
ymax0=10; ylen=-2.5;  ygap=-0.6
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
  my1=ymax-0.35
  my2=ymin+2.
  sx1=mx1+0.25
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
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set grads off'
*
 'set string 1 tl 5 0'
 'set strsiz 0.13 0.13'
'set grid on'
*'set time dec1980 dec2014'
'set t 1 66'
'set y 1'
'set ylint 0.5'
'set vrange -3. 3. 0.5'
'set yaxis -3. 3. 0.5'
'set cthick 6'
'set ccolor 1'
'set cmark 3'
if (iframe = 1)
'd -pc1'
endif
if (iframe = 2)
'd -pc2'
endif
if (iframe = 3)
'd -pc3'
endif
'run /cpc/home/wd52pp/bin/dline.gs 1 0 66 0'
'set string 1 tl 6 0'
if(iframe = 1);'draw string 'sx1' 'sy1' PC1 (40.6%)'; endif
if(iframe = 2);'draw string 'sx1' 'sy1' PC2 (9.8%)'; endif
if(iframe = 3);'draw string 'sx1' 'sy1' PC3 (7.6%)'; endif
if(iframe = 1);'draw string 'tlx' 'tly' a)'; endif
if(iframe = 2);'draw string 'tlx' 'tly' b)'; endif
if(iframe = 3);'draw string 'tlx' 'tly' c)'; endif
iframe=iframe+1
endwhile
'print'
'printim Fig3.png gif x1200 y1600'
*'c'
*'set vpage off'
*----------
*
*----------
