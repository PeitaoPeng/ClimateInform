'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/ca_prd/ac_2d_ca_opi_mon.7980-0102DJFM.mm10.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for monthly PRCP'
'draw string 4.25 10.2 DJFM 79/80-02/03, Maxmode=10'
'draw string 2.4 9.5 CONSTRUCTED ANALOGUE'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac(t=2)'
  'define sd2=ac(t=3)'
  'define sd3=pp(t=2)'
  'define sd4=pp(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
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
'set clevs  0.2 0.4 0.6 0.8'
'set ccols  0 22 24 26 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  0 month lead'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  1 month lead'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*
*'c'
 'set vpage off'
