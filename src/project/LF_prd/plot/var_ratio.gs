* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/temp_cams_land.jfm.50-02.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/temp_cams_land.jfm.50-02.ntd.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/temp_cams_land.jfm.50-02.wang_HP.ntd.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/temp_cams_land.jfm.50-02.wang_LP.ntd.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define vtot=ave(z*z,t=1,t=53)'
  'define vntd=ave(z.2*z.2,t=1,t=53)'
  'define vhp=ave(z.3*z.3,t=1,t=53)'
  'define vlp=ave(z.4*z.4,t=1,t=53)'
  'define vtrd=vtot-vntd'
  'define stdv1=100*vtrd/vtot'
  'define stdv2=100*vhp/vtot'
  'define stdv3=100*vlp/vtot'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
 'draw string 4.25 10.5 variance fractions (%) of linear trend, HP and LP'
 'draw string 4.25 10.2 2mt JFM 1950-2002'
*'draw string 5.5 7.5 cmap prate clim (79-01) (mm/day)'
*---------------------------set dimsnesion, page size and style
nframe=3
nframe2=3
xmin0=2.5;  xlen=3.5;  xgap=0.5
ymax0=9.5; ylen=-2.25;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+2.0
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
*
*'set mproj nps'
'set lat 25 80'
'set lon 190 310'
*'set yaxis -25 25 10'
*if(iframe > 8); 'set lat 0 80'; endif
*if(iframe > 8); 'set yaxis 0 80 20'; endif
'set frame off'
'set grads off'
'set grid off'
*'set map 15 1 2'
'set gxout shaded'
'set clevs  10 20 30 40 50 60 70'
'set ccols  0 21 22 23 24 25 27 29'
'set xlab off'
'set ylab off'
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
 if(iframe = 1); 'draw string 'titlx' 'titly' linear trend'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' HP'; endif
 if(iframe = 3); 'draw string 'titlx' 'titly' LP'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*'c'
 'set vpage off'
*----------
