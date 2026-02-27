'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export/hobbes/wd52pp/project/LF_prd/plot_cd/K_AC_temp_102_anom_1931-2001.djf.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.3(t=2))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 Optimal K and COR for DJF sfc temp (1961-2001)'
*'draw string 4.25 10.2 EOF1-3 reconstructed data'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.75;  xlen=5.0;  xgap=0.5
ymax0=9.0; ylen=-2.2;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+1.45
  titlx2=xmin+1.0
  titly=ymax+0.2
  bary=ymax-1.1
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set xlab off'
'set ylab off'
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
if(iframe = 1);
'set clevs  5 15 25';
'set ccols 29 25 22 0';
endif
if(iframe = 2);
'set clevs  0.3 0.4 0.5 0.6';
'set ccols 0 21 23 25 29';
endif
'set csmooth on'
'd ff'%iframe
 'set gxout contour'
if(iframe = 1);
'set clevs  5 15';
endif
if(iframe = 2);
'set clevs  0.3 0.4 0.5 0.6';
endif
*'d ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx1' 'titly' OPT K (COR criterion)'; endif
 if(iframe = 2); 'draw string 'titlx2' 'titly' COR (OPT K)'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn.gs 0.75 1 6.8 'bary''
endwhile
'print'
*'c'
 'set vpage off'
