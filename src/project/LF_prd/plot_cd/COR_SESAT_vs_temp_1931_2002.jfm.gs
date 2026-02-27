'reinit'
'open grid.ctl'
'open maskus.ctl'
'open /export-6/sgi9/wd52pp/project/LF_prd/plot_cd/COR_SESAT_vs_temp_1931_2002.jfm.ctl'
*
'enable print meta.test'
*
'set display color white'
'clear'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
'define fd1=oacres(grid.1(t=1),z.3(t=1))'
'define ff1=maskout(fd1,mask.2(t=1)-1)'
'define fd2=oacres(grid.1(t=1),z.3(t=2))'
'define ff2=maskout(fd2,mask.2(t=1)-1)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
  'draw string 4.25 10.5 RPC2 vs OBS(1 yr lag) for JFM sfc temp (1950-2002)'
* 'draw string 4.25 10.5 1yr Lagged Cor (T`bsfc`n to T`bsfc`n at SE) for JFM (1961-2002)'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe=2
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-1.4
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx1=xmin+1.3
  titlx2=xmin+1.5
  titly=ymax+0.2
  bary=ymin-0.6
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
 'set clevs  0.3 0.35 0.40 0.45 0.5 0.55'
 'set ccols 0 21 22 23 25 27 29'
*'set clevs  0.3 0.40 0.5 60'
*'set ccols 0 21 23 25 28'
*if(iframe = 2); 'set clevs  0.25 0.5 0.75'; endif
if(iframe = 2); 'set clevs  0.25 0.5 0.75 1. 1.25'; endif
*if(iframe = 2); 'set ccols 0 22 24 26 29'; endif
if(iframe = 2); 'set ccols 0 21 23 25 27 29'; endif
'set csmooth on'
'd ff'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
if(iframe = 1); 'draw string 'titlx1' 'titly' correlation'; endif
if(iframe = 2); 'draw string 'titlx1' 'titly' regression'; endif
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 1.0 0 4.25 'bary''
*
  iframe=iframe+1
endwhile
'print'
*'c'
 'set vpage off'
