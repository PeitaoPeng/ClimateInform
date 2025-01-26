'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_eocn.temp.uscd.jfm95-djf09.ts.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/skill/hss_temp.95-cur.cfs.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_enso.temp.uscd.jfm95-djf09.ts.ctl'
*'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.temp.uscd.jfm95-djf09.ts.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 HSS of Seasonal Temp Forecast (13mon mean)'
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
'set vrange -25 75'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 7 174'
'define hse=ave(hss,t-6,t+6)'
'define hscpc=ave(hs1.2,t-6,t+6)'
'define enso=ave(hss.4,t-6,t+6)'
'set t 7 174'
'define hscfs=ave(hs1.3,t-6,t+6)'
'set t 1 180'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
'd hse'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
'd hscpc'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 3'
'd hscfs'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
'd enso'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.6 6.9 EOCN mean=19.4'
'set string 2 tl 4'
'draw string 1.6 6.7 CPC(all grid pts) mean=11.2'
'set string 3 tl 4'
'draw string 1.6 6.5 CFSv1 mean=8.8'
'set string 4 tl 4'
'draw string 1.6 6.3 Nino34 Tele mean=5.5'
'print'
'printim hss_temp.ts.sm.png gif x800 y600'
*'c'
 'set vpage off'
