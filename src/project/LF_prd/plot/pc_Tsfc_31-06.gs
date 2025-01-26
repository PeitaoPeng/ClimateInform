* clim of itcz prate
'reinit'
'run /export/hobbes/wd52pp/bin/white.gs'
*
'open /export-12/cacsrv1/wd52pp/LF_prd/coef.temp_102_anom.djf.31-06.ctl'
'enable print  meta.clim'
'run /export/hobbes/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=coef(t=1)'
  'define stdv2=coef(t=2)'
  'define stdv3=coef(t=3)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.17 0.17'
 'draw string 4.25 10.0 PCs of US T`bsfc`n (DJF 32-06)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-2.75;  ygap=-0.15
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
'set xaxis 1932 2006 5'
'set xlab off'
 if(iframe = 3); 'set xlab on'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set vrange -4 4 0.5'
*if(iframe = 1); 'set yaxis -4 3 1'; endif
*if(iframe = 2); 'set yaxis -4 3 1'; endif
*if(iframe = 3); 'set yaxis -3 3.5 1'; endif
'd stdv'%iframe
'define zero=0.0'
'd zero'
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
'printim pc_Tsfc_31-06.djf.png gif x600 y900'
*'c'
 'set vpage off'
*----------
