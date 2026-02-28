'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_eocn.temp.uscd.jfm95-djf09.ts.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocn.temp.uscd.jfm95-djf09.ts.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.temp.uscd.jfm95-djf09.ts.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 Seasonal Cycle of HSS of Temp Forecast'
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
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
'set vrange -10 50'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 12'
'define eo=ave(hss,t+0,t=180,1yr)'
'define go=ave(hss.2,t+0,t=180,1yr)'
'define gov1=ave(hss.3,t+0,t=180,1yr)'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd eo'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd go'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd gov1'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.6 6.9 EOCN mean=17.8'
'set string 2 tl 4'
'draw string 1.6 6.7 OCN(opt K) mean=13.5'
'set string 3 tl 4'
'draw string 1.6 6.5 OCM(K=10) mean=13.2'
'print'
'printim hss_temp.ts.clim.ocn.png gif x800 y600'
*'c'
 'set vpage off'
