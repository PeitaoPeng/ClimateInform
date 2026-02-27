'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/var.temp_102_anom_1931-2001.djf.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define fd2=oacres(grid.1(t=1),z.3(t=2))'
'define fd3=oacres(grid.1(t=1),z.3(t=3))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define ff2=maskout(fd2/fd1,mask.2(t=1)-1)'
'define ff3=maskout(fd3/fd1,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 Variance of DJF sfc temp (1931-2001)'
 'draw string 4.25 10.2 w.r.t wmo clim'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.0;  ygap=-0.6
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.0
  titly=ymax+0.2
  bary=ymax-1.0
  barx=6.6
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set lat 24 51'
'set ylint 5'
'set xlab off'
'set ylab off'
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
'set clevs  0.2 0.3 0.4 0.5 0.6 0.7 0.8'
'set ccols  0 21 22 23 24 25 27 29'
if(iframe = 1); 'set clevs   1 3 5 7 9 11'; endif
if(iframe = 1); 'set ccols   0 21 23 24 25 27 29'; endif
'set csmooth on'
'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' total variance'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' fraction of HP'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' fraction of LP'; endif
 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.6 1 'barx' 'bary''
*
  iframe=iframe+1
endwhile
'print'
*'c'
 'set vpage off'
