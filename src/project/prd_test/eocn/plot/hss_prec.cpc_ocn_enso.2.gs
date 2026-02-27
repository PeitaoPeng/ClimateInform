'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_cpc.prec.uscd.jfm95-djf09.sp.enso.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.prec.jfm95-djf09.enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.prec.jfm95-djf09.enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_cpc.prec.uscd.jfm95-djf09.sp.no-enso.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.prec.jfm95-djf09.no-enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.prec.jfm95-djf09.no-enso.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
'enable print meta.fig16'
*
*---------------------------string/caption
 'define prec1=hs1'
 'define prec2=hs.2'
 'define prec3=hs.3'
 'define prec4=hs1.4'
 'define prec5=hs.5'
 'define prec6=hs.6'
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.2 HSS of Seasonal Prec Forecast'
'draw string 2.5 9.6 ENSO Seasonas'
'draw string 6.5 9.6 Non-ENSO Seasonas'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
xmin0=0.35;  xlen=3.8;  xgap=0.25
ymax0=9.2; ylen=-2.3;  ygap=-0.2
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=4.25
  titly=ymax+0.0
  titlx2=xmin+3.25
  titly2=ymin+0.75
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set x 1 36'
'set y 3 17'
'set xlab off'
'set ylab off'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 22 23 24 25 26 27 29'
*'set xlab off'
*'set ylab off'
'set xlabs 130W | 120W | 110W | 100W | 90W | 80W | 70W | 60W'
*'set yaxis -80 80 20'
'd prec'%iframe
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.12 0.12'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' CPC Official'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' OCN Method (K=10)'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' ENSO Tele Connection'; endif
*
 'set strsiz 0.11 0.11'
 if(iframe = 1); 'draw string 'titlx2' 'titly2' avg=3.7'; endif
 if(iframe = 2); 'draw string 'titlx2' 'titly2' avg=0.2'; endif
 if(iframe = 3); 'draw string 'titlx2' 'titly2' avg=6.0'; endif
 if(iframe = 4); 'draw string 'titlx2' 'titly2' avg=1.2'; endif
 if(iframe = 5); 'draw string 'titlx2' 'titly2' avg=3.1'; endif
 if(iframe = 6); 'draw string 'titlx2' 'titly2' avg=1.4'; endif
*
  iframe=iframe+1
endwhile
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1 0 4.25 1.5'
'print'
'printim hss_prec.cpc_ocn_enso.paper.2.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
