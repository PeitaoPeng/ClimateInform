'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/reof.temp_102_anom_1931-2001.djf.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),regr.3(t=1))'
'define ff1=-maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),regr.3(t=2))'
'define ff2=-maskout(fd2,mask.2(t=1)-1)'
'define fd3=oacres(grid.1(t=1),regr.3(t=3))'
'define ff3=-maskout(fd3,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 REOFs of DJF sfc temp (1931-2001)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.4
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat 24 51'
'set ylint 5'
'set lon -129 -65'
'set xlint 10'
'set grads off'
'set grid off'
'set poli on'
'set mpdset mres'
'set map 1 1 1'
*
'set gxout shaded'
'set grads off'
'set clevs  -0.9 -0.7 -0.5 -0.3  0.3 0.5 0.7 0.9'
'set ccols 49 47 45 43  0 23 25 27 29'
'set csmooth on'
'd ff'%iframe
'set gxout contour'
'set clevs  -0.9 -0.7 -0.5 -0.3 0.3 0.5 0.7 0.9'
'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' mode1 37%'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' mode2 28%'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' mode3 21%'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs'
endwhile
'print'
*'c'
 'set vpage off'
