'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.djf.1931-2001.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.mam.1931-2001.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.jja.1931-2001.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/ocn_pc_prd_temp.son.1931-2001.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.5(t=1))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
'define fd3=oacres(grid.1(t=1),z.4(t=1))'
'define ff3=maskout(fd3,mask.2(t=1)-1)'
'define fd4=oacres(grid.1(t=1),z.6(t=1))'
'define ff4=maskout(fd4,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
* 'draw string 4.25 10.5 EOF adjusted OCN prd skill (temporal cor)'
 'set strsiz 0.12 0.12'
*'draw string 4.25 10.2 T`bsfc`n (1961-2001)'
*---------------------------set dimsnesion, page size and style
nframe=4
nframe2=2
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
  titlx1=xmin+1.7
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
'set clevs  0.3 0.4 0.5 0.6';
*'set ccols  0 21 23 25 29';
'set ccols  0 82 84 86 88';
'set csmooth on'
'd ff'%iframe
 'set gxout contour'
'set clevs 0.3 0.4 0.5 0.6';
*'d ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
*if(iframe = 1); 'draw string 'titlx1' 'titly' DJF (EOF1,2; K=30,25)         '; endif
 if(iframe = 1); 'draw string 'titlx1' 'titly' DJF                           '; endif
*if(iframe = 2); 'draw string 'titlx1' 'titly' JJA (EOF1-6; K=18,15,28,3,7,4)'; endif
 if(iframe = 2); 'draw string 'titlx1' 'titly' JJA                           '; endif
*if(iframe = 3); 'draw string 'titlx1' 'titly' MAM (EOF1; K=15)              '; endif
 if(iframe = 3); 'draw string 'titlx1' 'titly' MAM                          '; endif
*if(iframe = 4); 'draw string 'titlx1' 'titly' SON (EOF1,3,5,6; K=11,8,17,1) '; endif
 if(iframe = 4); 'draw string 'titlx1' 'titly' SON                          '; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 1 0 4.25 4.75'
endwhile
'print'
*'c'
 'set vpage off'
