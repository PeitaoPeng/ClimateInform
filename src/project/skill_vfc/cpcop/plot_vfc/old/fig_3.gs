'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_temp.95-cur.cpc.ctl'
'open /export-12/cacsrv1/wd52pp/cpc_vfc/skill/hss_prec.95-cur.cpc.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
'enable print meta.fig3'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.;  xgap=0.75
ymax0=7.0; ylen=-5;  ygap=-0.65
*
'set t 1 12'
'define clm1=ave(nec,t+0,t=181,1yr)'
'define clm2=ave(nec.2,t+0,t=181,1yr)'
'modify clm1 seasonal'
'modify clm2 seasonal'
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+4.
  titly=ymax+0.3
  titlx2=xmin+4.
  titly2=ymin-0.4
  titlx3=xmin-0.6
  titly3=ymin+2.5
  strx1=xmin+1.
  stry1=ymax-0.4
  strx2=xmin+1.
  stry2=ymax-0.7
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
*'set frame off'
'set grads off'
*'set grid off'
*'set xlab off'
'set xlabs JFM | FMA | MAM | AMJ | MJJ | JJA | JAS | ASO | SON | OND | NDJ | DJF '
*'set ylab off'
'set vrange 0 100'
*'run /export/hobbes/wd52pp/bin/dline.gs 0 0 360 0'
'set gxout line'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 1'
'set t 1 12'
'd clm1'
'set cmark 0'
'set cstyle 1'
'set cthick 5'
'set ccolor 2'
'set t 1 12'
'd clm2'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 'titlx' 'titly' Ann cycle of grid number(%)'
 'draw string 'titlx2' 'titly2' Season'
 'set string 1 tc 4 90'
 'draw string 'titlx3' 'titly3' Grid number(%)'
 'set strsiz 0.14 0.14'
 'set string 1 tl 4 0'
 'draw string 'strx1' 'stry1' Temp forecast'
 'set string 2 tl 4'
 'draw string 'strx2' 'stry2' Prec forecast'
*----------
  iframe=iframe+1
endwhile
'print'
'printim Fig5.png gif x800 y600'
*'c'
 'set vpage off'
----------
