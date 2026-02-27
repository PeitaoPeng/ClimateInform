* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.sst.vs.SEASAT_5001jfm.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.sst_1yr_lag_to_SEASAT_5001jfm.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=corr'
  'define stdv2=corr.2'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.0 CORR(SST vs SEASAT) (JFM 50-02)'
*---------------------------set dimsnesion, page size and style
nframe=2
nframe2=2
xmin0=1.75;  xlen=5.0;  xgap=0.5
ymax0=9.0; ylen=-3.0;  ygap=-0.5
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
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set lat -40 70'
'set lon 120 360'
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
*'set frame off'
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  -0.6 -0.5 -0.4 -0.3 0.3 0.4 0.5 0.6'
'set ccols   48 46 44 42 0 22 24 26 28'
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
 if(iframe = 1); 'draw string 'titlx' 'titly' `3t`0=0'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' `3t`0=-1yr'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.8 0 4.25 1.75'
endwhile
'print'
*'c'
 'set vpage off'
*----------
