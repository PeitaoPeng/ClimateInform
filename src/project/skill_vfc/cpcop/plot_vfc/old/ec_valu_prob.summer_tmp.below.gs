'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/eco_valu_summer.below.prob.t2m.95-07.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.75 Economic Value of CPC Summer Season Prob T2m Forecast'
'draw string 5.5 7.4 Below Normal Case'
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
'set vrange 0 0.2'
'set xaxis 0 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 100'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
*'d tloop(ev1)'
*'d tloop(ev2)'
*'d tloop(ev3)'
*'d tloop(ev4)'
*'d tloop(ev5)'
*'d tloop(ev6)'
*'d tloop(ev7)'
*'d tloop(ev8)'
*'d tloop(ev9)'
'd tloop(ev7)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd tloop(ev8)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd tloop(ev9)'
*
'set string 1 tl 6'
'draw string 1.8 6.4 Pt=30%'
'set string 2 tl 6'
'draw string 1.8 6.1 Pt=20%'
'set string 3 tl 6'
'draw string 1.8 5.8 Pt=10%'
*
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'draw xlab cost-lose ratio'
'draw ylab V'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim ec_valu_prob.t2m.summer.b.png gif x800 y600'
*'c'
 'set vpage off'
*----------
