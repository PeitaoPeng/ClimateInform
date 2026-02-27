* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/rsd_reof.z200_5002jfm.ntd_ifrc_2.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=-regr(t=1)'
  'define stdv2=-regr(t=2)'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.8 Z200 projected to PCs of Pacific SSTs (JFM 50-02)'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=3.0;  xlen=2.5;  xgap=0.5
ymax0=9.5; ylen=-2.5;  ygap=-0.8
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.2
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj nps'
'set lat 20 90'
'set lon 0 360'
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  -40 -30 -20 -10 10 20 30 40'
'set ccols   49 47 45 43 0 23 25 27 29'
*'set xlab off'
*'set ylab off'
'd stdv'%iframe
'set gxout contour'
'set csmooth on'
*'set cint 0.5'
*'set ccolor 1'
* if(iframe = 6); 'set xlab on'; endif
* if(iframe = 12); 'set xlab on'; endif
*if(iframe > 8); 'set clevs -1 -0.8 -0.6 -0.4 -0.2 0.2 0.4 0.6 0.8 1'; endif
'set clopts -1 3 0.05'
'set cthick 4'
*'d stdv'%iframe
 'set string 1 tc 4'
 'set strsiz 0.13 0.13'
*----------
 if(iframe = 1); 'draw string 'titlx' 'titly' HP_SST_PC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' LP_SST_PC1'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 3.0'
endwhile
'print'
*'c'
 'set vpage off'
*----------
