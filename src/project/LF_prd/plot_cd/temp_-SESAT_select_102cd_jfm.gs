'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/temp_-SESAT_select_102cd_jfm.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.3(t=3))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
'define fd3=oacres(grid.1(t=1),z.3(t=5))'
'define ff3=maskout(fd3,mask.2(t=1)-1)'
'define fd4=oacres(grid.1(t=1),z.3(t=7))'
'define ff4=maskout(fd4,mask.2(t=1)-1)'
'define fd5=oacres(grid.1(t=1),z.3(t=9))'
'define ff5=maskout(fd5,mask.2(t=1)-1)'
'define fd6=oacres(grid.1(t=1),z.3(t=11))'
'define ff6=maskout(fd6,mask.2(t=1)-1)'
'define fd7=oacres(grid.1(t=1),z.3(t=13))'
'define ff7=maskout(fd7,mask.2(t=1)-1)'
'define fd8=oacres(grid.1(t=1),z.3(t=15))'
'define ff8=maskout(fd8,mask.2(t=1)-1)'
'define fd9=oacres(grid.1(t=1),z.3(t=2))'
'define ff9=maskout(fd9,mask.2(t=1)-1)'
'define fd10=oacres(grid.1(t=1),z.3(t=4))'
'define ff10=maskout(fd10,mask.2(t=1)-1)'
'define fd11=oacres(grid.1(t=1),z.3(t=6))'
'define ff11=maskout(fd11,mask.2(t=1)-1)'
'define fd12=oacres(grid.1(t=1),z.3(t=8))'
'define ff12=maskout(fd12,mask.2(t=1)-1)'
'define fd13=oacres(grid.1(t=1),z.3(t=10))'
'define ff13=maskout(fd13,mask.2(t=1)-1)'
'define fd14=oacres(grid.1(t=1),z.3(t=12))'
'define ff14=maskout(fd14,mask.2(t=1)-1)'
'define fd15=oacres(grid.1(t=1),z.3(t=14))'
'define ff15=maskout(fd15,mask.2(t=1)-1)'
'define fd16=oacres(grid.1(t=1),z.3(t=16))'
'define ff16=maskout(fd16,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.7 JFM sfc temp for SESAT < -stdv'
 'set strsiz 0.12 0.12'
*'draw string 4.25 10.2 74 89 90 91 97 99 00'
*---------------------------set dimsnesion, page size and style
nframe=16
nframe2=8
xmin0=2.00;  xlen=2.25;  xgap=0.0
ymax0=10.0; ylen=-1.00;  ygap=-0.2
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+0.45
  titly=ymax+0.175
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
  'set xlab off'
  'set ylab off'
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
'set clevs  -2.5 -2.0 -1.5 -1.0 -0.5 0.5 1.0 1.5 2.0 2.5';
'set ccols  49 47 45 43 41 0 21 23 25 27 29';
'd  ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx' 'titly' 1963'; endif
if(iframe = 2); 'draw string 'titlx' 'titly' 1964'; endif
if(iframe = 3); 'draw string 'titlx' 'titly' 1966'; endif
if(iframe = 4); 'draw string 'titlx' 'titly' 1968'; endif
if(iframe = 5); 'draw string 'titlx' 'titly' 1969'; endif
if(iframe = 6); 'draw string 'titlx' 'titly' 1970'; endif
if(iframe = 7); 'draw string 'titlx' 'titly' 1977'; endif
if(iframe = 8); 'draw string 'titlx' 'titly' 1978'; endif
if(iframe = 9); 'draw string 'titlx' 'titly' 1964'; endif
if(iframe = 10); 'draw string 'titlx' 'titly' 1965'; endif
if(iframe = 11); 'draw string 'titlx' 'titly' 1967'; endif
if(iframe = 12); 'draw string 'titlx' 'titly' 1969'; endif
if(iframe = 13); 'draw string 'titlx' 'titly' 1970'; endif
if(iframe = 14); 'draw string 'titlx' 'titly' 1971'; endif
if(iframe = 15); 'draw string 'titlx' 'titly' 1978'; endif
if(iframe = 16); 'draw string 'titlx' 'titly' 1979'; endif
*
  iframe=iframe+1
if(iframe = 14); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.6 0 4.25 0.25'; endif
endwhile
'print'
*'c'
 'set vpage off'
