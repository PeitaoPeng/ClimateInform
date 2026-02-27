'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/Prec.tc_bnd.jfm-djf.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/old/Prec.ab_lines.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8.25 Tercile Boundaries of JFM Prec: New vs Old'
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
'set lat 20 56'
'set lon 230 300'
if(iframe = 1)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs   0.2 0.4 0.6 0.8 1.'
'set ccols   0 21 23 25 27 29'
'd a'
endif
if(iframe = 2)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs  -1 -0.8 -0.6 -0.4 -0.2'
'set ccols   49 48 47 45 43 41'
'd b'
endif
if(iframe = 3)
*'set gxout contour'
*'set cint 2'
'set gxout grfill'
'set mpdset mres'
'set clevs   0.2 0.4 0.6 0.8 1.'
'set ccols   0 21 23 25 27 29'
'd a.2(t=2)'
endif
if(iframe = 4)
'set gxout contour'
'set cint 0.5'
'set gxout grfill'
'set mpdset mres'
'set clevs  -1 -0.8 -0.6 -0.4 -0.2'
'set ccols   49 48 47 45 43 41'
'd b.2(t=2)'
endif
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' upper_new'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' lower_new'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' lower_old'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' upper_old'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 0.5 0 'barx' 'bary''
endwhile
'print'
'printim tc_bnd_comp.prec.png gif x800 y600'
*----------
