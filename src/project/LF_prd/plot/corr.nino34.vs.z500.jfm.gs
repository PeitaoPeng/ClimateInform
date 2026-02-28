* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/obs/reanl/corr.nino34.vs.z500.50-03.jfm.ctl'
'enable print  corr.nino34.vs.z500.gr'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=corr'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 8.50 ENSO Impact'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=8.5; ylen=-4.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.85
  titly=ymax-0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
*'set xaxis 1950 2002 5'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set gxout shaded'
*'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
*'set clevs   -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 0.2 0.3 0.4 0.5 0.6 0.7'
*'set ccols  48 46 45 44 43 42 0 22 23 24 25 26 28'
 'set clevs   0'
 'set ccols  83 0'
*'set xlab off'
*'set ylab off'
'd stdv'%iframe
'set gxout contour'
'set csmooth on'
'set cint 0.2'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
*'d regr'
'd stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly' linear trend'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.9 0 4.25 3.65'
endwhile
'print'
*'c'
 'set vpage off'
*----------
