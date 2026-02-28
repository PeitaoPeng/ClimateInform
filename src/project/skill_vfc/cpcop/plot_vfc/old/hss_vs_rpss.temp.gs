'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/rpss_temp.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print meta.fig6'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 HSS vs RPSS for CPC Temp Forecast'
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
  strx=3.
  stry=6
nt=306
'draw string 'strx' 'stry' Cor=0.68'
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
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout scatter'
*'set t 1 216'
'set t 1 'nt''
'set vrange -0.5 0.5'
*'set vrange -0.35 0.35'
'set vrange2 -50 100'
'set cmark 5'
'd rpss.2;hs1'
'draw ylab HSS'
'draw xlab RPSS'
'set t 1'
'define hm=ave(hs1,t=1,t='nt')'
'define rm=ave(rpss.2,t=1,t='nt')'
'define hsd=sqrt(ave((hs1-hm)*(hs1-hm),t=1,t='nt'))'
'define rsd=sqrt(ave((rpss.2-rm)*(rpss.2-rm),t=1,t='nt'))'
'define hr=sqrt(ave((hs1-hm)*(rpss.2-rm),t=1,t='nt'))'
'define corr=hr/(hsd*rsd)'

*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim hss1.vs.rpss.temp.png gif x800 y600'
*'printim Fig6.png gif x800 y600'
*'c'
 'set vpage off'
*----------
