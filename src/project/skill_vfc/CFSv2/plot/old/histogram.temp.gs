'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/CFS_vfc/skill/T2m.hcst_fma81-jfm05.hstgrm.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.cpc.cons.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.3 PDF of CFS T2m Hcst at (282E,54N) for Each Season'
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
'set t 12'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set xaxis -6 6 1'
'set vrange2 -8 8'
'set vrange 0 40'
'set gxout line'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
it=1
while ( it <= 12 )
'set t 'it''
'd (hsg/360)*100'
it=it+1
endwhile
'draw xlab T2m anom'
'draw ylab Frequency(%)'
*----------
  iframe=iframe+1
endwhile
'print'
'printim hstgrm.temp.png gif x800 y600'
*'c'
 'set vpage off'
*----------
