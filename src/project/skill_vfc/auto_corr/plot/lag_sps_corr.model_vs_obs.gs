model=AMIP
*model=CanCM4i
*model=NCAR_CCSM4
area=Global
area_o=glb
var1=glp
var2=glo
'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/skill_ac/'model'.cor_s_lag1.z200.ctl'
'run /cpc/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.35 'area' Lag-1 Spatial Corr of 'model' vs OBS'
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
'set t 1 467'
'set vrange -0.6 1'
'set vrange2 0 1'
'd 'var1';'var2''
'draw ylab OBS'
'draw xlab Model Forecast'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim 'model'.lag_sps_corr.model_vs_obs.'area_o'.png gif x800 y600'
*'c'
 'set vpage off'
*----------
