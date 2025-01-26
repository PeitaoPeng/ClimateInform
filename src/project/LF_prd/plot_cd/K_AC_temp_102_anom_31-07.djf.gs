'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export/hobbes/wd52pp/project/LF_prd/plot_cd/K_AC_temp_102_anom_31-07.djf.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.16 0.16'
 'draw string 5.5 7 Optimal K of sfc Temp (DJF,1962-2007)'
*'draw string 4.25 10.2 EOF1-3 reconstructed data'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.5;  xlen=8.0;  xgap=0.5
ymax0=7.; ylen=-5.;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+3.
  titlx2=xmin+1.0
  titly=ymax+0.1
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
'set clevs  5 10 15 20 25';
'set ccols 41 42 43 45 47 49';
endif
if(iframe = 2);
'set clevs  0.3 0.4 0.5 0.6';
'set ccols 0 41 43 45 49';
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
*if(iframe = 1); 'draw string 'titlx1' 'titly' Optimal K (COR criterion)'; endif
 if(iframe = 2); 'draw string 'titlx2' 'titly' COR (OPT K)'; endif
*
  iframe=iframe+1
'run /export/hobbes/wd52pp/bin/cbarn.gs 1 0 5.5 1.75'
endwhile
'print'
'printim K_AC_DJF.grid.png gif x800 y600'
*'c'
 'set vpage off'
