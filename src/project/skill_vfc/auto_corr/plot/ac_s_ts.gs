*model=CanCM4i
model=AMIP
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/skill_ac/'model'.skill.cor_s.z200.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 5.5 7.6 Spatial Corr Skill of 'model' Z200 FCST'
'draw string 5.5 7.3 Lead-1 3-mon-mean'
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
'set vrange -1. 1.'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 468'
*'define mac=ave(glc,t-5,t+5)'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(glc))'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'd tloop(tpc))'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 4'
'd tloop(etc))'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
*'d tloop(hs2)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
 'define zero=0.'
 'set cstyle 1'
 'set cthick 6'
 'set cmark 0'
 'set ccolor 1'
 'd zero'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.15 0.15'
'set string 1 tl 4'
'draw string 2. 2.9 global: mean=0.41, lag-1 auto_cor=0.87'
'set string 2 tl 4'
'draw string 2. 2.6 tropic: mean=0.63, lag-1 auto_cor=0.87'
'set string 4 tl 4'
'draw string 2. 2.3 extratropics: mean=0.33, lag-1 auto_cor=0.81'
'print'
'printim 'model'.ac_s.ts.png gif x800 y600'
*'c'
 'set vpage off'
*----------
