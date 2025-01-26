'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/heidke_t2m_t.95-07.offi.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8.25 HSS2 of CPC Seasonal Temp Fcst & MC Test'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=4.75;  xgap=0.5
ymax0=7.5; ylen=-3.0;  ygap=-0.85
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.5
  titly=ymax+0.2
  barx=xmin+2.25
  bary=ymin-0.4
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set grads off'
'set grid off'
if(iframe = 1)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs   0 2.5 5 10 20 40 80'
'set ccols   0 21 23 24 25 26 27 29'
'd hs2'
endif
if(iframe = 2)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs   0 2.5 5 10 20 40 80'
'set ccols   0 21 23 24 25 26 27 29'
'd mhs2'
endif
if(iframe = 3)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs   1 2 3 4'
'set ccols   21 22 24 26 28'
'd sdv2'
endif
if(iframe = 4)
'set gxout contour'
'set cint 0.5'
'set gxout grfill'
'set mpdset mres'
'set clevs   -4 -3 -2 -1 0 1 2 3 4'
'set ccols   49 47 45 43 41 21 23 25 27 29'
'd hs2-mhs2'
endif
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' Official HSS2'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' Mean HSS2 in MC Test'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' Official HSS2 - Mean HSS2 in MC Test'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' STDV of HSS2 in MC Test'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 0.6 0 'barx' 'bary''
endwhile
'print'
'printim hs2_t2m.map.MC.png gif x800 y600'
*----------
