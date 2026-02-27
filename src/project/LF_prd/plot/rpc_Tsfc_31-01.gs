* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/rcoef.temp_102_anom_1931-2001.djf.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=-coef(t=1)'
  'define stdv2=-coef(t=2)'
  'define stdv3=-coef(t=3)'
  'define stdv4= coef(t=4)'
  'define stdv5= coef(t=5)'
  'define stdv6= coef(t=6)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.17 0.17'
 'draw string 4.25 10.5 RPCs of US T`bsfc`n (JFM 31-02)'
*---------------------------set dimsnesion, page size and style
nframe=6
nframe2=6
xmin0=1.0;  xlen=6.5;  xgap=0.5
ymax0=9.5; ylen=-1.5;  ygap=-0.15
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
'set xaxis 1931 2001 5'
'set xlab off'
 if(iframe = 6); 'set xlab on'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
*'set gxout shaded'
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
*'set gxout shaded'
*'set clevs  -0.9 -0.7 -0.5 -0.3 -0.1 0.1 0.3 0.5 0.7 0.9'
*'set ccols 49 47 45 43 41 0 21 23 25 27 29'
*'set xlab off'
*'set ylab off'
 if(iframe = 1); 'set yaxis -4 3 1'; endif
 if(iframe = 2); 'set yaxis -4 3 1'; endif
 if(iframe = 3); 'set yaxis -3 3.5 1'; endif
 if(iframe = 4); 'set yaxis -3.5 3 1'; endif
 if(iframe = 5); 'set yaxis -3.0 2.5 1'; endif
 if(iframe = 6); 'set yaxis -3.5 5. 1'; endif
'd stdv'%iframe
'define zero=0.0'
'd zero'
*'set gxout contour'
*'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
*'set clopts -1 3 0.05'
*'set cthick 4'
* 'd stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly'  RPC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly'  RPC2'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly'  RPC3'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly'  RPC4'; endif
 if(iframe = 5); 'draw string 'titlx' 'titly'  RPC5'; endif
 if(iframe = 6); 'draw string 'titlx' 'titly'  RPC6'; endif
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 2.3'
endwhile
'print'
*'c'
 'set vpage off'
*----------
