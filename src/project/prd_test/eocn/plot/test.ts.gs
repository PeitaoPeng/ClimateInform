'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/test_ts.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/fcst_ts.ocn.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 OCN forecast for a Synthesized Time Series'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.;  xgap=0.75
ymax0=7.0; ylen=-5;  ygap=-0.65
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.15
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -3 5'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 200'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'define zero=0.'
'd zero'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd t11'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd t14'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd t11.2'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.15 0.15'
'set string 3 tl 4'
'draw string 1.6 6.9 signal(T=100)'
'set string 1 tl 4'
'draw string 1.6 6.6 signal+noise(SNR=1)'
'set string 2 tl 4'
'draw string 1.6 6.3 OCN forecast (K=9)'
'print'
'printim test.ts.png gif x800 y600'
*'c'
 'set vpage off'
