'reinit'
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.temp_102cd_coef.vs.sst.50-01.djf.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define cor1=-corr(t=1)'
'define cor2=-corr(t=2)'
'define cor3=-corr(t=3)'
'define cor4=corr(t=4)'
'define cor5=corr(t=5)'
'define cor6=corr(t=6)'
'define reg1=-regr(t=1)'
'define reg2=-regr(t=2)'
'define reg3=-regr(t=3)'
'define reg4=regr(t=4)'
'define reg5=regr(t=5)'
'define reg6=regr(t=6)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 CORR of SST vs PCs of US T`bsfc`n'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.2 DJF 1949/50-2000/2001'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
xmin0=0.5;  xlen=3.50;  xgap=0.5
ymax0=9.5; ylen=-1.6;  ygap=-0.2
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.3
  titly=ymax+0.0
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set xlab off'
*'set ylab off'
'set lat -30 70'
'set ylint 15'
'set lon 0 360'
*'set xlint 20'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
'set clevs  -0.5 -0.4 -0.3 0.3 0.4 0.5'
'set ccols  47 45 43 0 23 25 27'
'set csmooth on'
'd cor'%iframe
'set gxout contour'
'set clevs  -0.9 -0.7 -0.5 -0.3 0.3 0.5 0.7 0.9'
* 'd reg'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' PC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' PC2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' PC3'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' PC4'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly' PC5'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly' PC6'; endif
*
  iframe=iframe+1
endwhile
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.8 0 4.25 3.75'
'print'
*'c'
 'set vpage off'
