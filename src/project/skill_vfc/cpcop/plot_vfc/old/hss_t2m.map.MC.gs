'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp_t.95-cur.cpc.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 4.25 10.5 HSS Map of CPC Seasonal Temp Forecast'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.;  xgap=0.75
ymax0=9.5; ylen=-3.5;  ygap=-0.8
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
'set grads off'
'set grid off'
if(iframe = 1)
'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 21 23 24 25 26 27 29'
'd hs1'
'set gxout contour'
'set clevs 90 95'
'd sg1'
endif
if(iframe = 2)
'set gxout grfill'
'set mpdset mres'
'set clevs   0 10 20 30 40 50 60'
'set ccols   0 21 23 24 25 26 27 29'
'd hs2'
'set gxout contour'
'set clevs 90 95'
'd sg2'
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 0.9 0 4.25 0.85'
'run /export/hobbes/wd52pp/bin/cbarn2.gs 1 1 7.35 5.6'
endif
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' All Season Data'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' Non-EC Only'; endif
*
  iframe=iframe+1
endwhile
'print'
'printim hss_t2m.map.MC.png gif x600 y800'
*'c'
* 'set vpage off'
*----------
