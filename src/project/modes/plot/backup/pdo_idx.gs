'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/obs/pdo_idx/pdo_jfm.1951-2010.ctl'
'open /export-12/cacsrv1/wd52pp/obs/pdo_idx/pdo_jfm.1951-2010.no-enso.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print Fig_1'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=9;  xgap=0.75
ymax0=7.5; ylen=-6.;  ygap=-1.
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+4.5
  titly=ymax+0.25
  lx1=xmin+0
  lx2=lx1+0.6
  lxx1=lx2+0.5
  lx3=lx2+1.2
  lx4=lx3+0.6
  lxx2=lx4+0.9
  lx5=lx4+2.0
  lx6=lx5+0.6
  lxx3=lx6+0.8
  lx7=lx6+2.0
  lx8=lx7+0.6
  lxx4=lx8+0.8
  ly=ymin-0.55
  ly2=ymin-0.45
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 11 0 8.5'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
 'set strsiz 0.18 0.18'
'draw string 'titlx' 'titly' PDO Index'
'set t 1'
*'set frame off'
'set grads off'
'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -3.0 3.'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set t 1 60'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd t'
'set cmark 3'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'set t 1 60'
'd t.2'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'define zero=0.'
'd zero'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
'set string 1 tl 5'
'draw string 1.5 7.3 Original'
'set string 2 tl 5'
'draw string 1.5 7.0 ENSO removed'
'set string 3 tl 5'
*'draw string 1.5 6.9 Eastern Pacific'
'set string 4 tl 5'
*'draw string 1.5 6.7 Major Hurrican Development Region'
  iframe=iframe+1
endwhile
'print'
'printim pdo.51-10jfm.png gif x800 y600'
*'c'
 'set vpage off'
*----------
