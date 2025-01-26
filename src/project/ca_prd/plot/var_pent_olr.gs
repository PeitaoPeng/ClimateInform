'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/obs/olr/olr_pent.7980-0102DJFM.72x72.anom.ctl'
'enable print meta.ac'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
*'draw string 4.25 3.0 STDV of PENTAD OLR (W/m`a2`n)'
*---------------------------set dimsnesion, page size and style
*
  'define var=ave(olr*olr,t=1,t=552)'
  'define sd1=sqrt(var)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.1 0.1'
*---------------------------set dimsnesion, page size and style
nframe=1
nframe2=1
xmin0=1.;  xlen=6.5;  xgap=0.0
ymax0=2.5; ylen=-1.5;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+3.25
  titly=ymax+0.1
* say xmin; say xmax; say ymin; say ymax
* 'set vpage 0 8.5 0.5 4'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj scaled'
'set lon 0 360'
'set lat -28.75 28.75'
*'set xlab off'
'set grads off'
*'set grid off'
 'set gxout shaded'
*'set gxout contour'
'set clevs  10 15 20 25 30'
'set ccols  0 21 23 25 27 29'
'set yaxis -28.75 28.75 10'
'd sd'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
'draw string 'titlx' 'titly' STDV of PENTAD OLR (W/m`a2`n)'
*
  iframe=iframe+1
*'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.8 0 4.25 7.8'
 'run /export-6/sgi9/wd52pp/bin/cbarn.gs'
endwhile
'print'
*
*'c'
 'set vpage off'
