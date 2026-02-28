'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 HSS of CPC Seasonal Temp Forecast (non-EC)'
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
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -50 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 181'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(hs2)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'set t 7 175'
'define sm1=ave(hs2,t-6,t+6)'
'set t 1 181'
'd tloop(sm1)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'set t 13 169'
'define sm2=ave(hs2,t-12,t+12)'
'set t 1 181'
'd tloop(sm2)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'set t 19 163'
'define sm3=ave(hs2,t-18,t+18)'
'set t 1 181'
'd tloop(sm3)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 8'
'set t 25 157'
'define sm4=ave(hs2,t-24,t+24)'
'set t 1 181'
'd tloop(sm4)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.5 6.9. all-grid ave=22.6 std=33.7'
'set string 2 tl 4'
'draw string 1.5 6.7 13-mon mean std=9.6'
'set string 3 tl 4'
'draw string 1.5 6.5 25-mon mean std=6.0'
'set string 4 tl 4'
'draw string 1.5 6.3 37-mon mean std=4.9'
'set string 8 tl 4'
'draw string 1.5 6.1 49-mon mean std=3.9'
'print'
'printim hss_temp.ts.cpc.sm.2.png gif x800 y600'
*'c'
 'set vpage off'
