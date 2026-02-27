'reinit'
'run /cpc/home/wd52pp/bin/white.gs'
*
'open /cpc/home/wd52pp/data/adam/real_prd.psi200_wkly.ctl'
'run /cpc/home/wd52pp/bin/rgbset2.gs'
*'enable print hdks_t2m.map.cpc.gr'
*
*---------------------------string/caption
'define prd1=pic/1e6'
'define prd2=cic/1e6'
*
'set string 1 tc 4'
'set strsiz 0.18 0.18'
'draw string 4.25 10. PSI200 IC vs Constructed Analog'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.;  xlen=6.5;  xgap=0.75
ymax0=9.5; ylen=-3.0;  ygap=-0.
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
  titly=ymax-0.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set t 1'
'set lat -20 87.5'
'set lon 0 360'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
*'set gxout contour'
*'set gxout grfill'
'set mpdset mres'
'set clevs   -30 -25 -20 -15 -10 -5 5 10 15 20 25 30'
'set ccols    49 48 47 45 43 41 0 21 23 25 27 28 29'
*'set xlab off'
*'set ylab off'
*'set yaxis -80 80 20'
'set cint 5'
'd prd'%iframe
'run /cpc/home/wd52pp/bin/dline.gs 0 0 360 0'
if(iframe = 1)
'run /cpc/home/wd52pp/bin/dline.gs 180 -20 180 87.5'
endif
'set gxout shaded'
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
if(iframe = 1); 'draw string 'titlx' 'titly' PSI200 IC'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' CONSTRUCTED PSI200 IC'; endif
*
  iframe=iframe+1
'run /cpc/home/wd52pp/bin/cbarn2.gs 0.9 0 4.25 3.25'
endwhile
'print'
'printim psiic.vs.cstct.map.png gif x1200 y1600'
*'c'
* 'set vpage off'
*----------
