'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/Prec.tc_bnd.jfm-djf.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/old/Prec.ab_lines.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/T2m.tc_bnd.jfm-djf.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/CFS_vfc/0data/old/t2m.ab_lines.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 5.5 8.35 Tercile Boundaries of JFM Data: New vs Old'
'draw string 3.2 7.85 Prec'
'draw string 7.7 7.85 T2m'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.75;  xlen=3.;  xgap=1.5
ymax0=7.25; ylen=-2.75;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.5
  titly=ymax+0.3
  barx=xmin+2.25
  bary=ymin-0.4
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set grads off'
'set grid off'
'set lat 20 48'
*'set lat 20 56'
'set lon 230 300'
if(iframe = 1)
'set gxout scatter'
'set cmark 3'
'set ccolor 1'
'set vrange -0.2 1.4'
'set vrange2 -0.2 1.4'
'd a;a.2(t=2)'
'draw ylab Old'
'draw xlab New'
endif
if(iframe = 2)
'set cmark 3'
'set ccolor 1'
'set gxout scatter'
'set vrange -1.5 0'
'set vrange2 -1.5 0'
'd b;b.2(t=2)'
'draw ylab Old'
'draw xlab New'
endif
if(iframe = 3)
'set cmark 3'
'set ccolor 1'
'set gxout scatter'
'set vrange 0 2.5.'
'set vrange2 0. 2.5.'
'd a.3;a.4(t=2)'
'draw ylab Old'
'draw xlab New'
endif
if(iframe = 4)
'set cmark 3'
'set ccolor 1'
'set gxout scatter'
'set vrange -2.0 0'
'set vrange2 -2.0 0'
'd b.3;b.4(t=2)'
'draw ylab Old'
'draw xlab New'
endif
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' upper'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' lower'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' lower'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' upper'; endif
*
  iframe=iframe+1
endwhile
'print'
'printim tc_bnd.new-vs-old.png gif x800 y600'
*----------
