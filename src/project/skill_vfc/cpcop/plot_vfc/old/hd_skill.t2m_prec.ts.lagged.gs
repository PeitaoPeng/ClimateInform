'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/lagged_hss.temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/lagged_hss.prec.95-cur.cpc.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
'enable print meta.fig15'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.14 0.14'
'draw string 5.5 7.25 HSS of auto verification (against lagged itself)'
*---------------------------set dimsnesion, page size and style
'set t 1 7'
'define hs11=hs41'
'define hs21=hs31'
'define hs12=hs41.2'
'define hs22=hs31.2'
nframe=2
nframe2=1
xmin0=1.25;  xlen=4.;  xgap=1.0
ymax0=6.5; ylen=-3;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.125
  titly=ymax+0.25
  strx1=xmin+2.
  stry1=ymin-0.3
  strx2=xmin-0.5
  stry2=ymax-1.5
  lgdx1=xmin+2.
  lgdy1=ymax-0.75
  lgdx2=xmin+2.
  lgdy2=ymax-1.
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange 0 100'
'set xaxis 0 6 1'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 7'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd hs1'%iframe
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 3'
'd hs2'%iframe
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
if(iframe = 1); 'draw string 'titlx' 'titly' Temp'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' Prec'; endif
 'set strsiz 0.12 0.12'
if(iframe = 1); 
'set string 1 tl 4'
'draw string 'lgdx1' 'lgdy1' Forecast'
'set string 1 tc 4'
'draw string 'strx1' 'stry1' Lag(month)'
'set string 1 tc 4 90'
'draw string 'strx2' 'stry2' HSS'
'set string 3 tl 4 0'
'draw string 'lgdx2' 'lgdy2' Observation'
endif
if(iframe = 2)
'set string 1 tl 4'
'draw string 'lgdx1' 'lgdy1' Forecast'
'set string 1 tc 4'
'draw string 'strx1' 'stry1' Lag(month)'
'set string 1 tc 4 90'
'draw string 'strx2' 'stry2' HSS'
'set string 3 tl 4 0'
'draw string 'lgdx2' 'lgdy2' Observation'
endif
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim Fig15.png gif x800 y600'
*'c'
 'set vpage off'
*----------
