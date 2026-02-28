* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/a1_b1_of_temp_cams_land.jfm.50-02.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/a1_b1_of_sst_5002jfm.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/a1_b1_of_z200_5002jfm.reg.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define stdv1=z*50'
  'define stdv2=z.2*50'
  'define stdv3=z.3*50'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 linear trend (JFM 1950-2002)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=2.;  xlen=4.5;  xgap=0.5
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
  titlx=xmin+2.25
  titly=ymax+0.2
  bary=ymax-1.25
  barx=xmax+0.5
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
'set mproj latlon'
'set frame on'
if(iframe = 1); 'set lat 25 80'; 'set lon 190 310'; 'set frame off'; endif
if(iframe = 2); 'set lat -40 70'; 'set lon 0 360'; endif
if(iframe = 3); 'set mproj nps'; 'set frame off'; 'set lat 20 90'; 'set lon 180 360'; endif
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set grads off'
*'set grid off'
*'set map 15 1 2'
'set gxout shaded'
if(iframe = 1); 'set clevs -2 -1 0 1 2 3 4 5'; 'set ccols 47 45 43 21 23 25 26 27 29'; endif
if(iframe = 2); 'set clevs  -1 -0.5 0 0.5 1'; 'set ccols 47 44 41 21 24 27'; endif
if(iframe = 3); 'set clevs  -120 -90 -60 -30 30 60 90 120'; 'set ccols 48 46 44 42 0 22 24 26 28'; endif
*'set clevs  10 20 30 40 50 60 70'
*'set ccols  0 21 22 23 24 25 27 29'
'set xlab off'
'set ylab off'
if(iframe = 2); 'set xlab on'; 'set ylab on'; endif
if(iframe = 3); 'set xlab on'; 'set ylab on'; endif
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
 if(iframe = 1); 'draw string 'titlx' 'titly' 2mt (`ao`nC/50yrs)'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' SST (`ao`nC/50yrs)'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' Z200 (m/50yrs)'; endif
*----------
 if(iframe = 1); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.5 1 'barx' 'bary''; endif
 if(iframe = 2); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.5 1 'barx' 'bary''; endif
 if(iframe = 3); 'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.5 1 'barx' 'bary''; endif
*
  iframe=iframe+1
endwhile
'print'
*'c'
 'set vpage off'
*----------
