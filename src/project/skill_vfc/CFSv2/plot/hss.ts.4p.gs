'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print hss.ts.4p.mega'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 8.25 HSS of Seasonal Forecast'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=4.75;  xgap=0.5
ymax0=7.5; ylen=-2.5;   ygap=-0.75
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titx=xmin+2.375
  tity=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
'set xlab on'
*
if (iframe = 2 | iframe = 4); 
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_cyc_temp.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_cyc_temp.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_cyc_temp.95-cur.cpc.ctl'
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_cyc_prec.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_cyc_prec.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_cyc_prec.95-cur.cpc.ctl'
'set xlab off'
'set t 1 12'
*'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
'set string 1 tl 4'
'set strsiz 0.09 0.09'
'draw string 0.4 1.66 JFM  FMA  MAM  AMJ  MJJ  JJA  JAS  ASO  SON  OND  NDJ  DJF '
'draw string 5.65 1.66 JFM  FMA  MAM  AMJ  MJJ  JJA  JAS  ASO  SON  OND  NDJ  DJF '
*'set xlint 1'
*'set ylab off'
'set vrange -10 50'
'set gxout line'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if (iframe = 2); 'd tloop(hs1.1)'; endif
if (iframe = 4); 'd tloop(hs1.4)'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if (iframe = 2); 'd tloop(hs1.2)'; endif
if (iframe = 4); 'd tloop(hs1.5)'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if (iframe = 2); 'd tloop(hs1.3)'; endif
if (iframe = 4); 'd tloop(hs1.6)'; endif
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'run /cpc/home/wd52pp/bin/dline.gs 1 0 12 0'
if (iframe = 2); 'draw string 'titx' 'tity' Seasonal Cycle of Temp HSS'; endif
if (iframe = 4); 'draw string 'titx' 'tity' Seasonal Cycle of Prec HSS'; endif
'close 6'
'close 5'
'close 4'
'close 3'
'close 2'
'close 1'
endif
*
if (iframe = 1 | iframe = 3); 
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_temp.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_temp.95-cur.cfsv2.ctl'
'open /cpc/home/wd52pp/data/cpc_vfc/skill/hss_prec.95-cur.cpc.ctl'
'open /cpc/home/wd52pp/data/CFS_vfc/skill/hss_prec.95-cur.cfs.ctl'
'open /cpc/home/wd52pp/data/CFSv2_vfc/skill/hss_prec.95-cur.cfsv2.ctl'
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'set vrange -10 50'
'set gxout line'
'set t 7 174'
'define cpct=ave(hs1,t-6,t+6)'
'define cfst=ave(hs1.2,t-6,t+6)'
'define cfs2t=ave(hs1.3,t-6,t+6)'
'define cpcp=ave(hs1.4,t-6,t+6)'
'define cfsp=ave(hs1.5,t-6,t+6)'
'define cfs2p=ave(hs1.6,t-6,t+6)'
*
*'set xlint 1'
'set t 1 180'
'set xaxis 1995 2010 2'
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 1'
if (iframe = 1); 'd  cfst'; endif
if (iframe = 3); 'd  cfsp'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 2'
if (iframe = 1); 'd  cfs2t'; endif
if (iframe = 3); 'd  cfs2p'; endif
'set cmark 0'
'set cstyle 1'
'set cthick 6'
'set ccolor 4'
if (iframe = 1); 'd  cpct'; endif
if (iframe = 3); 'd  cpcp'; endif
'set clopts -1 3 0.05'
'set string 1 tc 4'
'set strsiz 0.13 0.13'
'run /cpc/home/wd52pp/bin/dline.gs 0 0 180 0'
if (iframe = 1); 'draw string 'titx' 'tity' HSS of Temp'; endif
if (iframe = 3); 'draw string 'titx' 'tity' HSS of Prec'; endif
'close 6'
'close 5'
'close 4'
'close 3'
'close 2'
'close 1'
endif
*----------
'set xlab off'
iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'set strsiz 0.13 0.13'
'set string 1 tl 4'
'draw string 1.6 3.9 CFSv1 mean=9.0'
'set string 2 tl 4'
'draw string 1.6 3.7 CFSv2 mean=16.9'
'set string 4 tl 4'
'draw string 1.6 3.5 CPC   mean=11.2'
'set string 5 tl 4'
'set string 1 tl 4'
'draw string 6.85 3.9 CFSv1 mean=4.9'
'set string 2 tl 4'
'draw string 6.85 3.7 CFSv2 mean=7.4'
'set string 4 tl 4'
'draw string 6.85 3.5 CPC   mean=2.4'
'print'
'printim hss.ts.4p.png gif x800 y600'
*'c'
 'set vpage off'
*----------
