'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/prd_skill/nino34_nofltprd_sfcT_102CD.jfm1995-djf2010.2x2.ctl'
'run /export/hobbes/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
*
 'set string 1 tc 4'
 'set strsiz 0.18 0.18'
'draw string 5.5 7.5 Nino34 regr based fcst of DJF2009 Temp'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.5;  xlen=10;  xgap=0.75
ymax0=8.5; ylen=-8;  ygap=-0.85
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
'set t 180'
'set lat 21 52'
*'set lon 230 300'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set mpdset mres'
'set gxout grfill'
*'set gxout shaded'
'set clevs   -0.42 0.42'
'set ccols   49 0 29'
*'set xlab off'
*'set ylab off'
*'set yaxis -80 80 20'
'd t'
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
*if(iframe = 1); 'draw string 'titlx' 'titly' All-Grids'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly' non-EC'; endif
*
  iframe=iframe+1
*'run /export/hobbes/wd52pp/bin/cbarn2.gs 1. 0 5.5 1.4'
endwhile
'print'
'printim temp_prd.nino34.djf09.png gif x800 y600'
*'c'
* 'set vpage off'
*----------
