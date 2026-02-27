'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_s.vs.ss_t.rms.ctl'
'open /cpc/home/wd52pp/data/prd_test/eocn.acc_s.vs.ss_t.rms.sm.ctl'
'open /cpc/home/wd52pp/data/prd_test/gocn.acc_s.vs.ss_t.rms.ss.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print rpss_t2m.cfs.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 Spatial Corr of Seasonal Temp Forecast (13-mon mean)'
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
'set vrange -0.2 1.'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 264'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'set t 7 258'
'define ts=ave(acc,t-6,t+6)'
'define ts2=ave(acc15,t-6,t+6)'
'define ts3=ave(acc.3,t-6,t+6)'
'define ts4=ave(ac.2,t-6,t+6)'
*'define ts5=ave(acc10,t-6,t+6)'
*'d acc'
*'d acc15'
*'d acc.3'
*'d ac.2'
'set t 1 264'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd tloop(ts)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd tloop(ts2)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 5'
'd tloop(ts3)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd tloop(ts4)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 5'
*'d tloop(ts5)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
*'draw string 1.6 6.9 K(t,s): mean=0.35'
'draw string 1.6 6.9 K(t,s)'
'set string 2 tl 4'
*'draw string 1.6 6.6 K=15: mean=0.30'
'draw string 1.6 6.6 K=15'
'set string 5 tl 4'
*'draw string 1.6 6.3 K(t): mean=0.30'
'draw string 1.6 6.3 K(t)'
'set string 4 tl 4'
*'draw string 1.6 6.0 EOCN: mean=0.32'
'draw string 1.6 6.0 EOCN'
'set string 5 tl 4'
*'draw string 1.6 5.7 K=10: mean=0.26'
'print'
'printim acc.ts.png gif x800 y600'
*'c'
 'set vpage off'
*----------
