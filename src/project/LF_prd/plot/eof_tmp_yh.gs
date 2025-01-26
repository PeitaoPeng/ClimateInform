* eof of T2m over NA region
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/LF_prd/regr.temp_yh_anom.jfm.ctl'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
*
  'define eof1=regr(t=1)'
  'define eof2=regr(t=2)'
  'define eof3=regr(t=3)'
  'define eof4=regr(t=4)'
  'define eof5=regr(t=5)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 5.5 8.0 EOFs of NA 2mt JFM 1948-2007'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=0.5;  xlen=4.5;  xgap=0.5
ymax0=7.0; ylen=-2.20;  ygap=-0.75
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
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set lat 25 80'
'set lon 190 310'
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  -2 -1.5 -1 -0.5 0 0.5 1 1.5 2'
'set ccols   49 47 45 43 41 21 23 25 27 29'
'set xlab off'
'set ylab off'
'd eof'%iframe
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
'set clopts -1 3 0.05'
'set cthick 4'
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' EOF1 45%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' EOF2 22%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' EOF3 13%'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' EOF4  5%'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' EOF5  4%'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn.gs 1.0 0 5.5 1.0'
endwhile
'printim eof_t2m_yh_NA.jfm.png gif x800 y600'
'print'
*'c'
 'set vpage off'
*----------
