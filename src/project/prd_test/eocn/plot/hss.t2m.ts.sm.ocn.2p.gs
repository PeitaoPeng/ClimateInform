'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/prd_skill/hss_eocn.temp.uscd.jfm1995-djf2011.ts.ctl'
'open /cpc/home/wd52pp/data/prd_skill/hss_gocn.temp.uscd.jfm1995-djf2011.ts.ctl'
'open /cpc/home/wd52pp/data/prd_skill/hss_gocnv1.temp.uscd.jfm1995-djf2011.ts.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print hss.temp.ocn.2p.mega'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.12 0.12'
'draw string 4.25 10.175 HSS of Seasonal Temp Forecast (13mon mean)'
'draw string 4.25 5.43  Seasonal Cycle of HSS of Temp Forecast'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.5
ymax0=10.; ylen=-4;  ygap=-0.75
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
if(iframe=1);
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -25 75'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 7 198'
'define hse=ave(hss,t-6,t+6)'
'define hsg=ave(hss.2,t-6,t+6)'
'define hsgv1=ave(hss.3,t-6,t+6)'
'set t 1 204'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd hse'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd hsg'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd hsgv1'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
endif
if(iframe=2);
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
'define eo=ave(hss,t+0,t=204,1yr)'
'define go=ave(hss.2,t+0,t=204,1yr)'
'define gov1=ave(hss.3,t+0,t=204,1yr)'
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
'set ccolor 4'
'd gov1'
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
endif
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.4 9.7 EOCN mean=20.0'
'set string 2 tl 4'
'draw string 1.4 9.5 OCN(opt K) mean=18.3'
'set string 4 tl 4'
'draw string 1.4 9.3 OCN(K=10) mean=17.9'
'print'
'printim hss.temp.ocn.2p.png gif x600 y800'
*'c'
 'set vpage off'
