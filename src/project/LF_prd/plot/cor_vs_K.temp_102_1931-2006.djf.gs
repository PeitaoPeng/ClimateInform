* clim of itcz prate
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/LF_prd/cor_vs_K.temp_102.31-06.djf.ctl'
'enable print  meta.clim'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=cor(t=1)'
  'define stdv2=cor(t=2)'
  'define stdv3=cor(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 Skill of OCN predicted PCs vs K'
 'set strsiz 0.13 0.13'
 'draw string 4.25 10.2 US T`bsfc`n (DJF 1962-2006)'
 'set strsiz 0.17 0.17'
'draw string 4.25 1.8  K'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.5;  xlen=5.5;  xgap=0.5
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
  titlx=xmin+0.5
  titly=ymax-0.15
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set xaxis 1 30 2'
*'set xlab off'
if(iframe = 3); 'set xlab on'; endif
*if(iframe = 1); 'set yaxis 0.13 0.51 0.1'; endif
*if(iframe = 2); 'set yaxis 0.18 0.51 0.1'; endif
*if(iframe = 3); 'set yaxis -0.05 0.32 0.1'; endif
 if(iframe = 3); 'draw xlab K'; endif
'set vrange 0 0.5 0.1'
 'define zr=0.0'
 'd zr'
'set vrange 0 0.5 0.1'
'set yaxis 0. 0.5 0.1'
'd stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  PC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  PC2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  PC3'; endif
*
  iframe=iframe+1
endwhile
'print'
'printim cor_vs_K.temp_102_31-06.djf.png gif x600 y800'
*'c'
 'set vpage off'
*----------
