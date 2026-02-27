'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/CFSv2_vfc/skill/hss_temp_t.95-cur.cfsv2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
'define hds1=hs1s'
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.35 HSS of CFSv2 Temp Fcst for Winter Seasons'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.0;  xgap=0.75
ymax0=7.5; ylen=-6;  ygap=-0.85
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
'set t 1'
*'set lat 20 56'
*'set lon 230 300'
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
*'set yaxis -80 80 20'
'd hs1w'
'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d hds'%iframe
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly' All-data'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly' non-EC only'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 1.15'
endwhile
'print'
'printim hss_temp.map.cfsv2.win.png gif x800 y600'
*'c'
* 'set vpage off'
*----------
