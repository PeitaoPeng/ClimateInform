'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/ca_prd/ac_2d_ca_olr_pent.wcn.7980-0102DJFM.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for pentad OLR'
'draw string 4.25 10.2 El Nino winters, Maxmode=30'
'draw string 2.5 9.5 CONSTRUCTED ANALOG'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac2(t=1)'
  'define sd2=ac3(t=1)'
  'define sd3=ac4(t=1)'
  'define sd4=ac5(t=1)'
  'define sd5=ac6(t=1)'
  'define sd6=ac7(t=1)'
  'define sd7=pp2(t=1)'
  'define sd8=pp3(t=1)'
  'define sd9=pp4(t=1)'
  'define sd10=pp5(t=1)'
  'define sd11=pp6(t=1)'
  'define sd12=pp7(t=1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=6
xmin0=0.75;  xlen=3.2;  xgap=0.6
ymax0=9.0; ylen=-0.8;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.4
  titly=ymax+0.2
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
'set clevs  0.2 0.3 0.4 0.5 0.6 0.7'
'set ccols  0 21 22 23 25 27 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  0 pentad lead'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  1 pentad lead'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  2 pentad lead'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  3 pentad lead'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  4 pentad lead'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  5 pentad lead'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*
'c'
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for pentad OLR'
'draw string 4.25 10.2 La Nino winters, Maxmode=30'
'draw string 2.5 9.5 CONSTRUCTED ANALOG'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac2(t=2)'
  'define sd2=ac3(t=2)'
  'define sd3=ac4(t=2)'
  'define sd4=ac5(t=2)'
  'define sd5=ac6(t=2)'
  'define sd6=ac7(t=2)'
  'define sd7=pp2(t=2)'
  'define sd8=pp3(t=2)'
  'define sd9=pp4(t=2)'
  'define sd10=pp5(t=2)'
  'define sd11=pp6(t=2)'
  'define sd12=pp7(t=2)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=6
xmin0=0.75;  xlen=3.2;  xgap=0.6
ymax0=9.0; ylen=-0.8;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.4
  titly=ymax+0.2
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
'set clevs  0.2 0.3 0.4 0.5 0.6 0.7'
'set ccols  0 21 22 23 25 27 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  0 pentad lead'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  1 pentad lead'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  2 pentad lead'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  3 pentad lead'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  4 pentad lead'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  5 pentad lead'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
'c'
*
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for pentad OLR'
'draw string 4.25 10.2 NON-ENSO winters, Maxmode=30'
'draw string 2.5 9.5 CONSTRUCTED ANALOG'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac2(t=3)'
  'define sd2=ac3(t=3)'
  'define sd3=ac4(t=3)'
  'define sd4=ac5(t=3)'
  'define sd5=ac6(t=3)'
  'define sd6=ac7(t=3)'
  'define sd7=pp2(t=3)'
  'define sd8=pp3(t=3)'
  'define sd9=pp4(t=3)'
  'define sd10=pp5(t=3)'
  'define sd11=pp6(t=3)'
  'define sd12=pp7(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=12
nframe2=6
xmin0=0.75;  xlen=3.2;  xgap=0.6
ymax0=9.0; ylen=-0.8;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.4
  titly=ymax+0.2
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
'set clevs  0.2 0.3 0.4 0.5 0.6 0.7'
'set ccols  0 21 22 23 25 27 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  0 pentad lead'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  1 pentad lead'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  2 pentad lead'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  3 pentad lead'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  4 pentad lead'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  5 pentad lead'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*
 'set vpage off'
