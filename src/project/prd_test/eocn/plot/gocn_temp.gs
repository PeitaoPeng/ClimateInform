'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.djf.1991-2009.non-norm.2x2.ctl'
'open /export-12/cacsrv1/wd52pp/prd_skill/gocnv1prd_temp.jja.1991-2009.non-norm.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print xxx'
*
*---------------------------string/caption
 'define temp1=ave(t,t=5,t=19)'
 'define temp2=ave(t.2,t=5,t=19)'
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.5 OCN Forecasted Temp (1995-2009 avg)'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=1
xmin0=0.75;  xlen=4.5;  xgap=0.5
ymax0=6.5; ylen=-3.;  ygap=-0.85
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.25
  titly=ymax+0.2
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
*'set clevs   -0.2 0 0.2 0.4 0.6 0.8 1.0 1.2'
'set clevs   -0.3 0 0.3 0.6 0.9 1.2 1.5 1.8'
'set ccols   44 42 22 23 24 25 26 27 29'
*'set xlab off'
*'set ylab off'
*'set yaxis -80 80 20'
'd temp'%iframe
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
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' DJF'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' JJA'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn2.gs 0.9 0 5.5 2.75'
endwhile
'print'
'printim avg_temp.gocn.map.png gif x800 y600'
*'c'
* 'set vpage off'
*----------
