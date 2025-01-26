'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/emd/imf_monthly.pna.index.5001-0212.ctl'
'enable print  meta.imf'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=ori(t=1)'
  'define stdv2=ximf(t=1)'
  'define stdv3=ximf(t=2)'
  'define stdv4=ximf(t=3)'
  'define stdv5=ximf(t=4)'
  'define stdv6=ximf(t=5)'
  'define stdv7=ximf(t=6)'
  'define stdv8=ximf(t=7)'
  'define stdv9=rem(t=7)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 PNA index and its EMD (1950-2002)'
*---------------------------set dimsnesion, page size and style
nframe=9
nframe2=9
xmin0=0.75;  xlen=7.25;  xgap=0.0
ymax0=10.0; ylen=-0.9;  ygap=-0.05
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.5
  titly=ymax-0.05
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set xaxis 1949 2003 5'
'set xlab off'
 if(iframe = 9); 'set xlab on'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
*'set gxout shaded'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
*'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
*'set ccols 49 47 45 43 41 0 21 23 25 27 29'
*'set xlab off'
*'set ylab off'
 if(iframe = 1); 'set yaxis -6. 5 2'; endif
 if(iframe = 2); 'set yaxis -4. 3.5 2'; endif
 if(iframe = 3); 'set yaxis -2.5 2.5 1.0'; endif
 if(iframe = 4); 'set yaxis -1.4 1.4 0.5'; endif
 if(iframe = 5); 'set yaxis -0.8 0.8 0.5'; endif
 if(iframe = 6); 'set yaxis -1 1 0.5'; endif
 if(iframe = 7); 'set yaxis -0.35 0.4 0.2'; endif
 if(iframe = 8); 'set yaxis -0.25 0.3 0.2'; endif
 if(iframe = 9); 'set yaxis -0.25 0.25 0.2'; endif
 if(iframe = 10); 'set yaxis -0.08 0.08 0.05'; endif
 if(iframe = 11); 'set yaxis -0.45 0.2 0.2'; endif
'set cmark 0'
'd stdv'%iframe
'define zero=0.0'
'd zero'
*'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
* 'd stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  PNA'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  C1'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  C2'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  C3'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  C4'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  C5'; endif
 if(iframe = 7); 'draw string 'titlx' 'titly'  C6'; endif
 if(iframe = 8); 'draw string 'titlx' 'titly'  C7'; endif
 if(iframe = 9); 'draw string 'titlx' 'titly'  R'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 2.3'
endwhile
'print'
*'c'
 'set vpage off'
*----------
