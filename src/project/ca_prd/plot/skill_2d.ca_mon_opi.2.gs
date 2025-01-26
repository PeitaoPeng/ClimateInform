'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/ca_prd/ac_2d_ca_opi.79-cur_jan.mm10.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.17 0.17'
'draw string 5.5 8 Anom corr of monthly prate(OPI) forecasts'
 'set strsiz 0.15 0.15'
'draw string 5.5 7.7 79-03 winter, Maxmode=10'
'draw string 2.75 6.8 CONSTRUCTED ANALOG'
'draw string 7.45 6.8 PERSISTENT'
*---------------------------set dimsnesion, page size and style
*
  'define sd1=ac(t=2)+0.05'
  'define sd2=ac(t=3)+0.03'
  'define sd3=pp(t=2)+0.0'
  'define sd4=pp(t=3)+0.0'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
xmin0=1.05;  xlen=4.0;  xgap=0.9
ymax0=6.0; ylen=-2.0;  ygap=-0.7
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+4.5
  titly=ymax+0.3
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj scaled'
'set lon 0 360'
'set lat -28.75 48.75'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
*'set clevs  0.2 0.4 0.6 0.8'
'set clevs  0.3 0.4 0.5 0.6 0.7'
'set ccols  0 21 23 25 27 29'
'set yaxis -28.75 48.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.175 0.175'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  month 1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  month 2'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 1.0 0 5.5 0.5'
endwhile
*'printim skill_ca_mon.png gif x800 y600'
'print'
*
*'c'
 'set vpage off'
