'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec_t.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.prec.jfm95-djf09.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.prec.jfm95-djf09.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_cpc.prec.uscd.jfm95-djf09.sp.enso.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.prec.jfm95-djf09.enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.prec.jfm95-djf09.enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_cpc.prec.uscd.jfm95-djf09.sp.no-enso.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_gocnv1.prec.jfm95-djf09.no-enso.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/hss_nino34.prec.jfm95-djf09.no-enso.2x2.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig17'
*
*---------------------------string/caption
 'define prec1=hs1'
*'define prec1=hs1.4*0.58+hs1.7*0.42'
 'define prec2=hs.2'
 'define prec3=hs.3'
 'define prec4=hs1.4'
 'define prec5=hs.5'
 'define prec6=hs.6'
 'define prec7=hs1.7'
 'define prec8=hs.8'
 'define prec9=hs.9'
*
 'set string 1 tc 4 0'
 'set strsiz 0.15 0.15'
'draw string 5.5 8.0 HSS of Seasonal Prec Forecast'
 'set strsiz 0.13 0.13'
'draw string 2.25 7.55 All Seasons'
'draw string 5.5 7.55 ENSO Seasons'
'draw string 8.75 7.55 Non-ENSO Seasons'
*---------------------------set dimsnesion, page size and style
nframe=9
nframe2=3
nframe3=6
xmin0=0.75;  xlen=3.2;  xgap=0.0
ymax0=7.75; ylen=-2.65;  ygap= 0.85
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  if (iframe > nframe3); icx=3; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  if (iframe > nframe3); icy=iframe-nframe3; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=0.38
  titly=ymax-1.25
  titlx2=xmin+2.75
  titly2=ymin+1.
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
*'set ccols   0 22 23 24 25 26 27 29'
'set ccols   0 21 23 25 27 73 76 79'
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
 'set string 1 tc 4 90'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' CPC Official'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' OCN (K=15)'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' ENSO Tele'; endif
*
 'set string 1 tc 4 0'
 'set strsiz 0.11 0.11'
 if(iframe = 1); 'draw string 'titlx2' 'titly2' avg=2.4'; endif
 if(iframe = 2); 'draw string 'titlx2' 'titly2' avg=4.2'; endif
 if(iframe = 3); 'draw string 'titlx2' 'titly2' avg=4.1'; endif
 if(iframe = 4); 'draw string 'titlx2' 'titly2' avg=3.4'; endif
 if(iframe = 5); 'draw string 'titlx2' 'titly2' avg=4.9'; endif
 if(iframe = 6); 'draw string 'titlx2' 'titly2' avg=6.4'; endif
 if(iframe = 7); 'draw string 'titlx2' 'titly2' avg=1.1'; endif
 if(iframe = 8); 'draw string 'titlx2' 'titly2' avg=3.4'; endif
 if(iframe = 9); 'draw string 'titlx2' 'titly2' avg=1.1'; endif
*
  iframe=iframe+1
endwhile
'run /cpc/home/wd52pp/bin/cbarn2.gs 1 0 5.5 1.5'
'print'
*'printim hss_prec.cpc_ocn_enso.paper.3.png gif x800 y600'
'printim Fig17.png gif x800 y600'
*'c'
* 'set vpage off'
*----------
