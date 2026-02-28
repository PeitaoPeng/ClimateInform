'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/0data/temp01_forecast_below.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.75 CPC Prob (below normal) Fcst for Temp of AMJ 1998'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5;  xlen=10;  xgap=0.5
ymax0=7.5; ylen=-7.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3
  titly=ymax+0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 40'
'set gxout grid'
'd t'
iframe=iframe+1
endwhile
'print'
'printim t_pfcst_amj98.png gif x800 y600'
*'c'
* 'set vpage off'
*----------
