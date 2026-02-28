'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1-2.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1-3.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1-4.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1-5.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.eof1-6.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.4(t=1))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
'define fd3=oacres(grid.1(t=1),z.5(t=1))'
'define ff3=maskout(fd3,mask.2(t=1)-1)'
'define fd4=oacres(grid.1(t=1),z.6(t=1))'
'define ff4=maskout(fd4,mask.2(t=1)-1)'
'define fd5=oacres(grid.1(t=1),z.7(t=1))'
'define ff5=maskout(fd5,mask.2(t=1)-1)'
'define fd6=oacres(grid.1(t=1),z.8(t=1))'
'define ff6=maskout(fd6,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 OCN prd skill by using more EOFs'
 'set strsiz 0.12 0.12'
 'draw string 4.25 10.2 temporal cor for DJF T`bsfc`n (1961-2001)'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=3
xmin0=0.75;  xlen=3.35;  xgap=0.3
ymax0=9.2; ylen=-1.7;  ygap=-0.4
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+0.4
  titly=ymax+0.2
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
'set clevs  -0.3 0 0.3 0.4 0.5 0.6';
'set ccols    45 42 0 21 23 25 29';
'set csmooth on'
'd ff'%iframe
 'set gxout contour'
'set clevs 0.3 0.4 0.5 0.6';
* 'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx1' 'titly' EOF1  '; endif
 if(iframe = 2); 'draw string 'titlx1' 'titly' EOF1-2'; endif
 if(iframe = 3); 'draw string 'titlx1' 'titly' EOF1-3'; endif
 if(iframe = 4); 'draw string 'titlx1' 'titly' EOF1-4'; endif
 if(iframe = 5); 'draw string 'titlx1' 'titly' EOF1-5'; endif
 if(iframe = 6); 'draw string 'titlx1' 'titly' EOF1-6'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 1 0 4.25 2.5'
endwhile
'print'
*'c'
 'set vpage off'
