'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
*'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.feb.ic_jan.ctl'
*'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.mar.ic_jan.ctl'
*'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.apr.ic_jan.ctl'
*'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.may.ic_jan.ctl'
'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.aug.ic_jul.ctl'
'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.sep.ic_jul.ctl'
'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.oct.ic_jul.ctl'
'open /export-6/cacsrv1/wd52pp/obs/prcp/skill_1d_ca_opi_7902.nov.ic_jul.ctl'
'enable print  meta.ac_1d'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define sd1=cr(t=2)'
  'define sd2=cr'
  'define sd3=cr.2'
  'define sd4=cr.3'
  'define sd5=cr.4'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Spatial AC of CA & PRD for Tropical PRATE'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=5
xmin0=0.75;  xlen=7.0;  xgap=0.0
ymax0=10.0; ylen=-1.4;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.6
  titly=ymax+0.20
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set xaxis 1980 2001 2'
*'set xlab off'
* if(iframe = 8); 'set xlab on'; endif
'set grads off'
*'set grid off'
'set gxout bar'
'set bargap 50'
'set barbase 0'
'set ccolor 39'
'set vrange -0.4 1.0'
'set ylint 0.2'
'set xaxis 1980 2001 2'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*if(iframe = 1); 'draw string 'titlx' 'titly'  CA  for Jan'; endif
*if(iframe = 2); 'draw string 'titlx' 'titly'  prd for Feb'; endif
*if(iframe = 3); 'draw string 'titlx' 'titly'  prd for Mar'; endif
*if(iframe = 4); 'draw string 'titlx' 'titly'  prd for Apr'; endif
*if(iframe = 5); 'draw string 'titlx' 'titly'  prd for May'; endif
 if(iframe = 1); 'draw string 'titlx' 'titly'  CA  for Jul'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  prd for Aug'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  prd for Sep'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  prd for Oct'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  prd for Nov'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 2.3'
endwhile
'print'
'c'
 'set vpage off'
*----------
  'define sd1=cr(t=3)'
  'define sd2=cr.2(t=3)'
  'define sd3=cr.3(t=3)'
  'define sd4=cr.4(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 Spatial AC of Persistent PRD for Tropical PRATE'
'draw string 4.25 10.2 From Jul data, 1980-2001'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=4
xmin0=0.75;  xlen=7.0;  xgap=0.0
ymax0=8.1; ylen=-1.4;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.6
  titly=ymax+0.20
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set xaxis 1980 2001 2'
*'set xlab off'
* if(iframe = 8); 'set xlab on'; endif
'set grads off'
*'set grid off'
'set gxout bar'
'set bargap 50'
'set barbase 0'
'set ccolor 39'
'set vrange -0.4 1.0'
'set ylint 0.2'
'set xaxis 1980 2001 2'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  prd for Aug'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  prd for Sep'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  prd for Oct'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  prd for Nov'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 2.3'
endwhile
'print'
*'c'
