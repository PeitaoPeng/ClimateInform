'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset.gs'
*
'open pers_vs_yr.1957-2013.para.ctl'
'open nino34.ndjfm.para.1957-2013.ctl'
*
*'enable print sst.eof_pc.meta'
*
*---------------------------string/caption
 'set string 1 tc 5'
 'set strsiz 0.12 0.12'
'draw string 4.25 10. NINO3.4 SST(K) vs Z200 Persistency in AMIP-GOGA'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
nframe3=3
xmin0=2.5;  xlen=3.5;  xgap=0.1
ymax0=9.4; ylen=-2.;  ygap=-0.8
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
  sx1=xmin+1.75
  sx2=xmin-0.6
  sy1=ymin-0.25
  sy2=ymin+1.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*
'set gxout scatter'
*
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
'set grid on'
'set grads off'
'set t 1 57'
*'set ylint 1'
'set vrange 0 8 1'
'set vrange2 0 2.5'
*'set yaxis -2 3 0.5'
if (iframe = 1)
'set cmark 5'
'd p3;abs(sst.2)'
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
'draw string 'sx1' 'sy1' # of Ensemble Members'
'set string 1 tc 5 90'
'draw string 'sx2' 'sy2' ABS NINO3.4 SST(K)'
'set string 1 tl 5 0'
'draw string 'tlx' 'tly' (a)3-mon Persistence'
endif
if (iframe = 2)
'set cmark 5'
'd p4;abs(sst.2)'
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
'draw string 'sx1' 'sy1' # of Ensemble Members'
'set string 1 tc 5 90'
'draw string 'sx2' 'sy2' ABS NINO3.4 SST(K)'
'set string 1 tl 5 0'
'draw string 'tlx' 'tly' (b)4-mon Persistence'
endif
if (iframe = 3)
'set cmark 5'
'd p5;abs(sst.2)'
'set string 1 tc 5 0'
'set strsiz 0.12 0.12'
'draw string 'sx1' 'sy1' # of Ensemble Members'
'set string 1 tc 5 90'
'draw string 'sx2' 'sy2' ABS NINO3.4 SST(K)'
'set string 1 tl 5 0'
'draw string 'tlx' 'tly' (c)5-mon Persistence'
endif
iframe=iframe+1
endwhile
'print'
'printim pers_vs_nino34.scatter.para.2.png gif x600 y800'
*'c'
*'set vpage off'
*----------
*
*----------
