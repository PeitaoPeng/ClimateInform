* clim of itcz prate
'reinit'
'run /export-6/sgi9/wd52pp/bin/white.gs'
*
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.temp.vs.rsd_rcoef.z200_5002jfm.ntd_ifrc_3.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/corr.temp.vs.trend.ctl'
'open /export-6/cacsrv1/wd52pp/LF_prd/var_temp_cams_land.jfm.50-02.ctl'
'enable print  meta.clim'
'run /export-6/sgi9/wd52pp/bin/rgbset.gs'
*
*
  'define vt=var.3'
  'define v1=regr.2*regr.2'
  'define v2=regr(t=1)*regr(t=1)'
  'define v3=regr(t=2)*regr(t=2)'
  'define v4=regr(t=3)*regr(t=3)'
  'define stdv1=100*v1/vt'
  'define stdv3=100*v2/vt'
  'define stdv2=100*v3/vt'
  'define stdv4=100*v4/vt'
  'define stdv5=100*(v1+v2+v3+v4)/vt'
*
*---------------------------string/caption
 'set string 1 tc 4'
 'set strsiz 0.15 0.15'
'draw string 4.25 10.5 percentage of variance explained by linear trend & SST indices'
'draw string 4.25 10.2 JFM 2mt 1950-2002'
*---------------------------set dimsnesion, page size and style
nframe=5
nframe2=2
xmin0=0.5;  xlen=3.25;  xgap=0.5
ymax0=9.0; ylen=-2.20;  ygap=-0.5
*
iframe=1
while ( iframe <= nframe )
  icx=1; if (iframe > nframe2); icx=2; endif
  xmin=xmin0+(icx-1)*(xlen+xgap)
  xmax=xmin+xlen
  icy=iframe; if (iframe > nframe2); icy=iframe-nframe2; endif
  ymax=ymax0+(icy-1)*(ylen+ygap)
  ymin=ymax+ylen
  titlx=xmin+1.625
  titly=ymax+0.2
* say xmin; say xmax; say ymin; say ymax
  'set vpage 0 8.5 0 11'
  'set parea 'xmin' 'xmax' 'ymin' 'ymax
  if(iframe=5); 'set parea '2.625' '5.875' '1.6' '3.8; endif
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
'set clevs  5 10 15 20 25 30 35 40'
'set ccols  0 21 22 23 24 25 26 27 28'
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
 if(iframe = 3); 'draw string 'titlx' 'titly' SST_HP RPC1'; endif
 if(iframe = 2); 'draw string 'titlx' 'titly' SST_LP RPC1'; endif
 if(iframe = 4); 'draw string 'titlx' 'titly' SST_LP RPC2'; endif
 if(iframe = 5); 'draw string 4.25 4.0 SUM'; endif
*
  iframe=iframe+1
'run /export-6/sgi9/wd52pp/bin/cbarn.gs 0.7 0 4.25 1.0'
endwhile
'print'
*'c'
 'set vpage off'
*----------
