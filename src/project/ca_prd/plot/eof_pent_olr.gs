'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/ca_prd/eof.olr_pent.DJFM.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
  'define sd1=10*eof(t=1)'
  'define sd2=10*eof(t=2)'
  'define sd3=10*eof(t=3)'
  'define sd4=10*eof(t=4)'
  'define sd5=10*eof(t=5)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*'draw string 4.25 10.5 EOFs of HP Pentad OLR'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=5
xmin0=1.;  xlen=6.5;  xgap=0.6
ymax0=9.5; ylen=-1.0;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.20
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 0 360'
'set lat -28.75 28.75'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
'set ccols   49 47 45 43 41 0 21 23 25 27 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly'  EOF1  5.5%'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly'  EOF2  5.3%'; endif
*if(iframe = 3); 'draw string 'titlx' 'titly'  EOF3  3.4%'; endif
*if(iframe = 4); 'draw string 'titlx' 'titly'  EOF4  3.0%'; endif
*if(iframe = 5); 'draw string 'titlx' 'titly'  EOF5  2.6%'; endif
 if(iframe = 1); 'draw string 'titlx' 'titly'  EOF1  11.0%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  EOF2  5.5%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  EOF3  4.1%'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  EOF4  3.4%'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  EOF5  2.7%'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.8'
endwhile
'print'
*
*'c'
