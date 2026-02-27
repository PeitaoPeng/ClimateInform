'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/avg_cd.temp.1931-cur.48MRM.anom.ctl'
'run /export-6/sgi9/wd52pp/bin/rgbset2.gs'
'enable print sfcT.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.5 US 102CD avg sfc T (48MRM)'
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
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
*'set ylab off'
'set vrange -1 1'
*'run /export-6/sgi9/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set time jan1935 dec2003'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'd tloop(t)'
'set clopts -1 3 0.05'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn2.gs 1.0 0 5.5 0.5'
endwhile
'print'
'printim sfcT.png gif x800 y600'
*'c'
 'set vpage off'
*----------
