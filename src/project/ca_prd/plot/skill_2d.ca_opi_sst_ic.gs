'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.feb.sst_ic_jan.ctl'
'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.mar.sst_ic_jan.ctl'
'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.apr.sst_ic_jan.ctl'
'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.may.sst_ic_jan.ctl'
'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.jun.sst_ic_jan.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.aug.sst_ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.sep.sst_ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.oct.sst_ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.nov.sst_ic_jul.ctl'
*'open /export-6/cacsrv1/wd52pp/ca_prd/skill_ca_opi_7902.dec.sst_ic_jul.ctl'
'enable print  meta.ac_2d'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define sd1=cr'
  'define sd2=cr.2'
  'define sd3=cr.3'
  'define sd4=cr.4'
  'define sd5=cr.5'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Temporal AC of SST based CA Pred for Tropical PRATE'
'draw string 4.25 10.2 From Jan SST data, 1980-2001'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=5
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
'set lon 0 360'
'set lat -28.75 28.75'
*'set xlab off'
'set grads off'
*'set grid off'
'set gxout shaded'
'set clevs -0.8 -0.6 -0.4 0.4 0.6 0.8'
'set ccols  47 44 42 0 22 24 27'
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
