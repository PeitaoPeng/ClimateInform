'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
 'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.feb.ic_jan.ctl'
 'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.mar.ic_jan.ctl'
 'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.apr.ic_jan.ctl'
 'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.may.ic_jan.ctl'
 'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.jun.ic_jan.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.aug.ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.sep.ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.oct.ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.nov.ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.dec.ic_jul.ctl'
'enable print  meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define sd1=cr(t=2)'
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Temporal AC of CA for Tropical PRATE'
'draw string 4.25 10.2 1980-2001'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=0.75;  xlen=7.0;  xgap=0.0
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
  titlx=xmin+1.5
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
'set clevs -0.7 -0.5 -0.3 0.3 0.5 0.7'
'set ccols  47 44 42 0 22 24 27'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  CA for Jan'; endif
*if(iframe = 1); 'draw string 'titlx' 'titly'  CA  for Jul'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 7.8'
endwhile
'print'
'c'
*
  'define sd1=cr.1'
  'define sd2=cr.2'
  'define sd3=cr.3'
  'define sd4=cr.4'
  'define sd5=cr.5'
  'define sd6=cr(t=3)'
  'define sd7=cr.2(t=3)'
  'define sd8=cr.3(t=3)'
  'define sd9=cr.4(t=3)'
  'define sd10=cr.5(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for monthly PRATE'
'draw string 4.25 10.2 1980-2001, Jan IC'
'draw string 2.5 9.5 CONSTRUCTED ANALOG'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5
xmin0=0.75;  xlen=3.3;  xgap=0.6
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
'set clevs  0.3 0.5 0.7 0.9'
'set ccols  0 22 24 26 28'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  pred for Feb'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  pred for Mar'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  pred for Apr'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  pred for May'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  pred for Jun'; endif
*if(iframe = 1); 'draw string 'titlx' 'titly'  pred for Aug'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly'  pred for Sep'; endif
*if(iframe = 3); 'draw string 'titlx' 'titly'  pred for Oct'; endif
*if(iframe = 4); 'draw string 'titlx' 'titly'  pred for Nov'; endif
*if(iframe = 5); 'draw string 'titlx' 'titly'  pred for Dec'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.8'
endwhile
'print'
*
'c'
 'set vpage off'
*----------
  'define sd1=cr(t=4)'
  'define sd2=cr.2(t=4)'
  'define sd3=cr.3(t=4)'
  'define sd4=cr.4(t=4)'
  'define sd5=cr.5(t=4)'
  'define sd6=cr(t=3)'
  'define sd7=cr.2(t=3)'
  'define sd8=cr.3(t=3)'
  'define sd9=cr.4(t=3)'
  'define sd10=cr.5(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Skill (Temporal AC) of Prediction for monthly PRATE'
'draw string 4.25 10.2 1980-2001, Jan IC'
'draw string 2.5 9.5 AVG of CA & PS'
'draw string 6.0 9.5 PERSISTENT'
*---------------------------set dimsnesion, page size and style
nframe=10
nframe2=5
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
'set clevs  0.3 0.5 0.7 0.9'
'set ccols  0 22 24 26 28'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  pred for Feb'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  pred for Mar'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  pred for Apr'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  pred for May'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  pred for Jun'; endif
*if(iframe = 1); 'draw string 'titlx' 'titly'  pred for Aug'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly'  pred for Sep'; endif
*if(iframe = 3); 'draw string 'titlx' 'titly'  pred for Oct'; endif
*if(iframe = 4); 'draw string 'titlx' 'titly'  pred for Nov'; endif
*if(iframe = 5); 'draw string 'titlx' 'titly'  pred for Dec'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.8'
endwhile
'print'
*'c'
 'set vpage off'
